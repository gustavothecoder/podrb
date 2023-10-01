# frozen_string_literal: true

module Pod
  module Commands
    class Episodes < Base
      ALL_COLUMNS = %w[id title release_date duration link].freeze
      private_constant :ALL_COLUMNS

      def call(podcast_id, options = {})
        parsed_options = parse_options(options)
        columns = parsed_options["fields"] || ALL_COLUMNS
        order_by = parsed_options["order_by"] || "id"

        db = Pod::Storage::SQL.new(db: pod_db_dir)
        sql_code = <<~SQL
          select #{columns.join(", ")}
          from episodes
          where podcast_id = #{podcast_id}
          order by #{order_by};
        SQL
        records = db.query(sql_code, Pod::Entities::Episode)

        build_success_response(
          details: records.empty? ? :not_found : :records_found,
          metadata: {records: records, columns: columns}
        )
      rescue Pod::Storage::Exceptions::WrongSyntax => exc
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
