# frozen_string_literal: true

require "thor"

require_relative "commands"
require_relative "outputs/text"
require_relative "storage/sql"

module Pod
  class CLI < Thor
    # https://github.com/rails/thor/issues/728#issuecomment-642798887
    def self.exit_on_failure?
      true
    end

    desc "version", "Displays the pod version"
    map %w[-V --version] => :version
    def version
      puts VERSION
    end

    desc "init", "Creates the pod config files"
    def init
      puts "Creating config files..."

      result = Pod::Commands::Init.call

      puts Pod::Outputs::Text::Init.call(result)
    end

    desc "add FEED", "Adds a podcast to the Pod database"
    method_option :sync_url, type: :string, default: "", desc: "Pod will use this URL to sync the podcast."
    def add(feed)
      puts "Adding the podcast..."

      result = Pod::Commands::Add.call(feed, options)

      puts Pod::Outputs::Text::Add.call(result)
    end

    desc "table NAME", "List NAME records"
    def table(name)
      result = Pod::Commands::Table.call(name)

      puts Pod::Outputs::Text::Table.call(result)
    end
  end
end
