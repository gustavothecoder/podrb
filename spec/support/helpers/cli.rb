# frozen_string_literal: true

require 'open3'

module Helpers
  module CLI
    extend self

    def run_cmd(cmd)
      stdout, stderr, _ = Open3.capture3(cmd)

      (stdout.empty? ? stderr : stdout).chomp
    end
  end
end
