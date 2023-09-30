# frozen_string_literal: true

require "thor"

require_relative "commands"
require_relative "outputs/text"
require_relative "storage/sql"
require_relative "shell_interface"

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

    # TODO: reverse episodes order before creating records
    desc "add FEED", "Adds a podcast to the Pod database"
    method_option :sync_url, type: :string, default: "", desc: "Pod will use this URL to sync the podcast."
    def add(feed)
      puts "Adding the podcast..."

      result = Pod::Commands::Add.call(feed, options)

      puts Pod::Outputs::Text::Add.call(result)
    end

    desc "podcasts", "List the podcast records"
    method_option :fields, type: :array, default: [], desc: "Select the fields that will be displayed."
    def podcasts
      result = Pod::Commands::Podcasts.call(options)

      puts Pod::Outputs::Text::Podcasts.call(result)
    end

    # TODO: add `order` option
    desc "episodes PODCAST_ID", "List the podcast episodes"
    method_option :fields, type: :array, default: [], desc: "Select the fields that will be displayed."
    def episodes(podcast_id)
      result = Pod::Commands::Episodes.call(podcast_id, options)

      puts Pod::Outputs::Text::Episodes.call(result)
    end

    desc "open EPISODE_ID", "Open a episode in the browser"
    # TODO
    # method_option :archive, type: :boolean, default: false, desc: "Archive the episode."
    def open(episode_id)
      result = Pod::Commands::Open.call(episode_id)

      Pod::ShellInterface.call(result[:metadata])

      puts Pod::Outputs::Text::Open.call(result)
    end

    # TODO
    # desc "archive EPISODE_ID", "Archive the episode."

    # TODO
    # desc "sync PODCAST_ID", "Synce the podcast."

    # TODO
    # desc "delete PODCAST_ID", "Delete the podcast from pod's database."
  end
end
