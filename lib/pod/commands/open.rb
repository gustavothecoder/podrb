module Pod
  module Commands
    class Open < Base
      def call(episode_id, options = {})
        parsed_options = parse_options(options)

        db = Pod::Storage::SQL.new(db: pod_db_dir)
        episode = db.query(
          "select link from episodes where id = #{episode_id}",
          Pod::Entities::Episode
        )[0]
        return build_failure_response(details: :not_found) if episode.nil?

        browser = parsed_options["browser"] || "firefox"
        cmd = "#{browser} #{episode.link}"
        cmd << " && bundle exec pod archive #{episode_id}" if parsed_options["archive"]

        build_success_response(
          details: :episode_found,
          metadata: {cmd: cmd}
        )
      end
    end
  end
end
