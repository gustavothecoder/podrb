# frozen_string_literal: true

require "open3"

module TestHelpers
  module CLI
    def self.run_cmd(cmd)
      stdout, stderr, _ = Open3.capture3(cmd)

      (stdout.empty? ? stderr : stdout).chomp
    end
  end

  module Path
    extend self

    def config_dir
      home_dir = ENV["HOME"]
      return "" if home_dir.nil?

      home_dir + "/.config/pod"
    end

    def db_dir
      config_dir + "/pod.db"
    end
  end
end
