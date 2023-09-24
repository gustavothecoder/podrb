# frozen_string_literal: true

module Pod
  module Commands
    class Podcasts < Base
      def call
        db = Pod::Storage::SQL.new(db: pod_db_dir)
        records = db.query("select name, description, feed, website from podcasts")
        build_success_response(
          details: records.empty? ? :empty_table : :records_found,
          data: Pod::Entities::Podcast.batch_initialize(records)
        )
      end
    end
  end
end
