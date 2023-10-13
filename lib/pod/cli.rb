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

    desc "episodes PODCAST_ID", "List the podcast episodes"
    method_option :fields, type: :array, default: [], desc: "Select the fields that will be displayed."
    method_option :order_by, type: :string, default: "id", desc: "Choose how pod will order the episodes."
    method_option :all, type: :boolean, default: false, desc: "List archived episodes too."
    def episodes(podcast_id)
      result = Pod::Commands::Episodes.call(podcast_id, options)

      puts Pod::Outputs::Text::Episodes.call(result)
    end

    desc "open EPISODE_ID", "Open a episode in the browser"
    method_option :browser, type: :string, default: "firefox", desc: "Choose the browser."
    method_option :archive, type: :boolean, default: false, desc: "Archive the episode."
    def open(episode_id)
      result = Pod::Commands::Open.call(episode_id, options)

      Pod::ShellInterface.call(result[:metadata])

      puts Pod::Outputs::Text::Open.call(result)
    end

    desc "archive EPISODE_ID", "Archive the episode"
    def archive(episode_id)
      result = Pod::Commands::Archive.call(episode_id)

      puts Pod::Outputs::Text::Archive.call(result)
    end

    desc "dearchive EPISODE_ID", "Dearchive the episode."
    def dearchive(episode_id)
      result = Pod::Commands::Dearchive.call(episode_id)

      puts Pod::Outputs::Text::Dearchive.call(result)
    end

    desc "delete PODCAST_ID", "Delete the podcast from pod's database."
    def delete(podcast_id)
      result = Pod::Commands::Delete.call(podcast_id)

      puts Pod::Outputs::Text::Delete.call(result)
    end

    desc "sync PODCAST_ID", "Sync the podcast."
    # TODO
    # method_option :feed, type: :string, default: '', desc: "The feed that should be used."
    def sync(podcast_id)
      result = Pod::Commands::Sync.call(podcast_id)

      puts Pod::Outputs::Text::Sync.call(result)
    end
  end
end
