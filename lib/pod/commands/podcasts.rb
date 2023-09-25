# frozen_string_literal: true

module Pod
  module Commands
    class Podcasts < Base
      ALL_COLUMNS = %w[id name description feed website].freeze
      private_constant :ALL_COLUMNS

      def call(options = {})
        parsed_options = parse_options(options)
        columns = parsed_options["fields"] || ALL_COLUMNS
        db = Pod::Storage::SQL.new(db: pod_db_dir)
        records = db.query(
          "select #{columns.join(", ")} from podcasts",
          Pod::Entities::Podcast
        )
        build_success_response(
          details: records.empty? ? :empty_table : :records_found,
          metadata: {records: records, columns: columns}
        )
      end
    end
  end
end