# frozen_string_literal: true

require_relative "../infrastructure/feed_parser"

module Pod
  module Commands
    class Sync < Pod::Commands::BaseRunner
      def call(podcast_id)
        db = Infrastructure::Storage::SQL.new(db: pod_db_dir)
        podcast = db.query("select feed from podcasts where id = #{podcast_id}").first
        return build_failure_response(details: :not_found) if podcast.nil?

        parsed_feed = Infrastructure::FeedParser.call(podcast.feed)
        parsed_feed.episodes.each do |e|
          db.execute <<-SQL
              insert or ignore into episodes
              (title, release_date, podcast_id, duration, link, external_id)
              values (
                "#{escape_double_quotes(e.title)}",
                "#{escape_double_quotes(e.release_date)}",
                #{podcast_id},
                "#{escape_double_quotes(e.duration)}",
                "#{escape_double_quotes(e.link)}",
                "#{e.external_id}"
              );
          SQL
        end
        build_success_response(details: :podcast_synchronized)
      end
    end
  end
end
