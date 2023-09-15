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

        build_success_response(details: :successfully_added)
      rescue Pod::Storage::Exceptions::ConstraintViolation
        build_failure_response(details: :already_added)
      end

      private

      def missing_data?(feed)
        feed.podcast.nil?
      end
    end
  end
end
