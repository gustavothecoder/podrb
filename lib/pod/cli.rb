# frozen_string_literal: true

require 'thor'

require_relative './commands.rb'
require_relative './outputs/text.rb'
require_relative './storage/sql.rb'

module Pod
  class CLI < Thor
    # https://github.com/rails/thor/issues/728#issuecomment-642798887
    def self.exit_on_failure?
      true
    end

    desc 'version', 'Displays the pod version'
    map %w[-V --version] => :version
    def version
      puts VERSION
    end

    desc 'init', 'Creates the pod config files'
    def init
      puts 'Creating config files...'

      result = Pod::Commands::Init.call

      puts Pod::Outputs::Text::Init.new(result).call
    end
  end
end
