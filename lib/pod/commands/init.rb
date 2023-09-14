# frozen_string_literal: true

require "fileutils"

module Pod
  module Commands
    class Init < Base
      def call
        home_dir = ENV["HOME"]
        return home_not_found if home_dir.nil?

        pod_config_dir = home_dir + "/.config/pod"
        return already_initialized if Dir.exist?(pod_config_dir)

        FileUtils.mkdir_p(pod_config_dir)

        db = Pod::Storage::SQL.new(db: "#{pod_config_dir}/pod.db")

        db.execute <<-SQL
          create table podcasts (
            name text not null,
            description text,
            feed text not null,
            website text
          );
        SQL

        success_response
      rescue SystemCallError, Pod::Storage::Exceptions::CantStartConnection
        cannot_create_initial_config
      end

      private

      def home_not_found
        build_failure_response(details: :home_not_found)
      end

      def already_initialized
        build_success_response(details: :already_initialized)
      end

      def success_response
        build_success_response(details: :successfully_initialized)
      end

      def cannot_create_initial_config
        build_failure_response(details: :cannot_create_initial_config)
      end
    end
  end
end
