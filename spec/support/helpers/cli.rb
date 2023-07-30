# frozen_string_literal: true

require 'open3'

module Helpers
  module CLI
    extend self

    def run_cmd(cmd)
      Open3.capture3(cmd)
    end
  end
end
