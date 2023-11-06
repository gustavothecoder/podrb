# frozen_string_literal: true

module Pod
  module Commands
    class Podcasts < Base
      ALL_COLUMNS = %w[id name description feed website].freeze
      private_constant :ALL_COLUMNS

      def call(options = {})
        parsed_options = parse_options(options)
        columns = parsed_options["fields"] || ALL_COLUMNS
        db = Infrastructure::Storage::SQL.new(db: pod_db_dir)
        records = db.query("select #{columns.join(", ")} from podcasts")
        build_success_response(
          details: records.empty? ? :empty_table : :records_found,
          metadata: {records: records, columns: columns}
        )
      rescue Infrastructure::Storage::Exceptions::WrongSyntax => exc
        cause = exc.message
        if cause.include?("no such column")
          invalid_column = cause.delete_prefix("no such column: ")
          build_failure_response(
            details: :invalid_column,
            metadata: {invalid_column: invalid_column}
          )
        end
      end
    end
  end
end
