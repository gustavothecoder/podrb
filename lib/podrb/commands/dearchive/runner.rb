# frozen_string_literal: true

module Podrb
  module Commands
    module Dearchive
      class Runner < Podrb::Commands::BaseRunner
        def call(episode_id)
          db = Infrastructure::Storage::SQL.new(db: podrb_db_dir)

          if db.query("select id from episodes where id = #{episode_id}").empty?
            return build_failure_response(details: :not_found)
          end

          sql_code = <<~SQL
            update episodes
            set archived_at = null
            where id = #{episode_id};
          SQL
          db.execute(sql_code)

          build_success_response(details: :episode_dearchived)
        end
      end
    end
  end
end
