# frozen_string_literal: true

module Pod
  module Commands
    class Table < Base
      COLUMNS_MAP = {
        "podcasts" => "name, description, feed, website"
      }
      ENTITY_MAP = {
        "podcasts" => Pod::Entities::Podcast
      }
      private_constant :COLUMNS_MAP, :ENTITY_MAP

      def call(name)
        db = Pod::Storage::SQL.new(db: pod_db_dir)
        records = db.query("select #{COLUMNS_MAP[name]} from #{name}")
        build_success_response(
          details: records.empty? ? :empty_table : :records_found,
          data: ENTITY_MAP[name].batch_initialize(records)
        )
      rescue Pod::Storage::Exceptions::WrongSyntax
        build_failure_response(details: :invalid_table)
      end
    end
  end
end
