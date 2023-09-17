# frozen_string_literal: true

require_relative "../feed_parser"

module Pod
  module Commands
    class Add < Base
      def call(feed)
        parsed_feed = Pod::FeedParser.call(feed)

        if missing_data?(parsed_feed)
          return build_failure_response(details: :badly_formatted)
        end

        db = Pod::Storage::SQL.new(db: pod_db_dir)
        db.transaction do
          podcast = parsed_feed.podcast
          db.execute <<-SQL
            insert into podcasts
            (name, description, feed, website)
            values (
              "#{podcast.name}",
              "#{podcast.description}",
              "#{podcast.feed}",
              "#{podcast.website}"
            );
          SQL

          inserted_podcast_id = db.query("select id from podcasts order by id desc limit 1;")[0][0]
          parsed_feed.episodes.each do |e|
            db.execute <<-SQL
              insert into episodes
              (title, release_date, podcast_id, duration, description, link)
              values (
                "#{e.title}",
                "#{e.release_date}",
                #{inserted_podcast_id},
                "#{e.duration}",
                "#{e.description}",
                "#{e.link}"
              );
            SQL
          end
        end

        build_success_response(details: :successfully_added)
      rescue Pod::Storage::Exceptions::ConstraintViolation
        build_failure_response(details: :already_added)
      end

      private

      def missing_data?(feed)
        feed.podcast.nil? || feed.episodes.nil?
      end
    end
  end
end
