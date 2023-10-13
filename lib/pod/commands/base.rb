# frozen_string_literal: true

module Pod
  module Commands
    class Base
      def self.call(*args)
        command = new
        if command.method(:call).parameters.empty?
          command.call
        else
          command.call(*args)
        end
      end

      private

      def build_success_response(details:, metadata: nil)
        {status: :success, details: details, metadata: metadata}
      end

      def build_failure_response(details:, metadata: nil)
        {status: :failure, details: details, metadata: metadata}
      end

      def home_dir
        ENV["HOME"]
      end

      def pod_config_dir
        home_dir + "/.config/pod"
      end

      def pod_db_dir
        "#{pod_config_dir}/pod.db"
      end

      def parse_options(opts)
        opts.select { |k, v| v != "" && v != [] }
      end

      def escape_double_quotes(str)
        str.gsub("\"", "\"\"")
      end
    end
  end
end
