# frozen_string_literal: true

require 'thor'

module Pod
  class CLI < Thor
    # https://github.com/rails/thor/issues/728#issuecomment-642798887
    def self.exit_on_failure?
      true
    end

    desc 'version', 'displays the pod version'
    def version
      puts VERSION
    end
  end
end
