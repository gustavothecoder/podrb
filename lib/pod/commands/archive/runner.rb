# frozen_string_literal: true

module Pod
  module Commands
    module Archive
      class Runner < Pod::Commands::BaseRunner
        def call(episode_id)
          db = Infrastructure::Storage::SQL.new(db: pod_db_dir)

          if db.query("select id from episodes where id = #{episode_id}").empty?
            return build_failure_response(details: :not_found)
          end

          sql_code = <<~SQL
            update episodes
            set archived_at = '#{Time.now.iso8601}'
            where id = #{episode_id};
          SQL
          db.execute(sql_code)

          build_success_response(details: :episode_archived)
        end
      end
    end
  end
end
