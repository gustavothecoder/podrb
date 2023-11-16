# frozen_string_literal: true

module Podrb
  module Commands
    module Update
      class Runner < Podrb::Commands::BaseRunner
        def call(podcast_id, options = {})
          parsed_options = parse_options(options)
          return build_failure_response(details: :invalid_options) if parsed_options.empty?

          db = Infrastructure::Storage::SQL.new(db: podrb_db_dir)
          if db.query("select id from podcasts where id = #{podcast_id}").empty?
            return build_failure_response(details: :not_found)
          end

          sql_code = <<~SQL
            update podcasts
            set feed = '#{options["feed"]}'
            where id = #{podcast_id};
          SQL
          db.execute(sql_code)
          build_success_response(details: :podcast_updated)
        end
      end
    end
  end
end
