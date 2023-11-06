# frozen_string_literal: true

require_relative "../infrastructure/feed_parser"

module Pod
  module Commands
    class Add < Base
      def call(feed, options = {})
        parsed_feed = Infrastructure::FeedParser.call(feed)
        parsed_options = parse_options(options)

        if missing_data?(parsed_feed)
          return build_failure_response(details: :badly_formatted)
        end

        db = Infrastructure::Storage::SQL.new(db: pod_db_dir)
        db.transaction do
          podcast = parsed_feed.podcast
          podcast_feed = parsed_options["sync_url"] || podcast.feed
          return build_failure_response(details: :missing_sync_url) if podcast_feed.nil?

          db.execute <<-SQL
            insert into podcasts
            (name, description, feed, website)
            values (
              "#{escape_double_quotes(podcast.name)}",
              "#{escape_double_quotes(podcast.description)}",
              "#{escape_double_quotes(podcast_feed)}",
              "#{escape_double_quotes(podcast.website)}"
            );
          SQL

          inserted_podcast_id = db.query("select id from podcasts order by id desc limit 1;").first.id
          parsed_feed.episodes.each do |e|
            db.execute <<-SQL
              insert into episodes
              (title, release_date, podcast_id, duration, link, external_id)
              values (
                "#{escape_double_quotes(e.title)}",
                "#{escape_double_quotes(e.release_date)}",
                #{inserted_podcast_id},
                "#{escape_double_quotes(e.duration)}",
                "#{escape_double_quotes(e.link)}",
                "#{e.external_id}"
              );
            SQL
          end
        end

        build_success_response(details: :successfully_added)
      rescue Infrastructure::Storage::Exceptions::ConstraintViolation
        build_failure_response(details: :already_added)
      end

      private

      def missing_data?(feed)
        feed.podcast.nil? || feed.episodes.nil?
      end

      def escape_double_quotes(str)
        str.gsub("\"", "\"\"")
      end
    end
  end
end
