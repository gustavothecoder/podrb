# frozen_string_literal: true

module Pod
  module Commands
    class Open < Base
      def call(episode_id)
        db = Pod::Storage::SQL.new(db: pod_db_dir)
        episode = db.query(
          "select link from episodes where id = #{episode_id}",
          entity: Pod::Entities::Episode
        )[0]
        return build_failure_response(details: :not_found) if episode.nil?

        build_success_response(
          details: :can_open,
          metadata: {cmd: "/usr/bin/firefox #{episode.link}"}
        )
      end
    end
  end
end
