# frozen_string_literal: true

module Podrb
  module Commands
    module Delete
      class Runner < Podrb::Commands::BaseRunner
        def call(podcast_id)
          db = Infrastructure::Storage::SQL.new(db: podrb_db_dir)

          if db.query("select id from podcasts where id = #{podcast_id}").empty?
            return build_failure_response(details: :not_found)
          end

          sql_code = <<~SQL
            delete from episodes
            where podcast_id = #{podcast_id};
          SQL
          db.execute(sql_code)

          sql_code = <<~SQL
            delete from podcasts
            where id = #{podcast_id};
          SQL
          db.execute(sql_code)

          build_success_response(details: :podcast_deleted)
        end
      end
    end
  end
end
