# frozen_string_literal: true

require "thor"

require_relative "commands"
require_relative "infrastructure/storage/sql"
require_relative "infrastructure/shell_interface"

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

      result = Pod::Commands::Init::Runner.call

      puts Pod::Commands::Init::Output.call(result)
    end

    desc "add FEED", "Adds a podcast to the Pod database"
    method_option :sync_url, type: :string, default: "", desc: "Pod will use this URL to sync the podcast."
    def add(feed)
      puts "Adding the podcast..."

      result = Pod::Commands::Add::Runner.call(feed, options)

      puts Pod::Commands::Add::Output.call(result)
    end

    desc "podcasts", "List the podcast records"
    method_option :fields, type: :array, default: [], desc: "Select the fields that will be displayed."
    def podcasts
      result = Pod::Commands::Podcasts::Runner.call(options)

      puts Pod::Commands::Podcasts::Output.call(result)
    end

    desc "episodes PODCAST_ID", "List the podcast episodes"
    method_option :fields, type: :array, default: [], desc: "Select the fields that will be displayed."
    method_option :order_by, type: :string, default: "id", desc: "Choose how pod will order the episodes."
    method_option :all, type: :boolean, default: false, desc: "List archived episodes too."
    def episodes(podcast_id)
      result = Pod::Commands::Episodes::Runner.call(podcast_id, options)

      puts Pod::Commands::Episodes::Output.call(result)
    end

    desc "open EPISODE_ID", "Open a episode in the browser"
    method_option :browser, type: :string, default: "firefox", desc: "Choose the browser."
    method_option :archive, type: :boolean, default: false, desc: "Archive the episode."
    def open(episode_id)
      result = Pod::Commands::Open::Runner.call(episode_id, options)

      Infrastructure::ShellInterface.call(result[:metadata])

      puts Pod::Commands::Open::Output.call(result)
    end

    desc "archive EPISODE_ID", "Archive the episode"
    def archive(episode_id)
      result = Pod::Commands::Archive::Runner.call(episode_id)

      puts Pod::Commands::Archive::Output.call(result)
    end

    desc "dearchive EPISODE_ID", "Dearchive the episode."
    def dearchive(episode_id)
      result = Pod::Commands::Dearchive::Runner.call(episode_id)

      puts Pod::Commands::Dearchive::Output.call(result)
    end

    desc "delete PODCAST_ID", "Delete the podcast from pod's database."
    def delete(podcast_id)
      result = Pod::Commands::Delete::Runner.call(podcast_id)

      puts Pod::Commands::Delete::Output.call(result)
    end

    desc "sync PODCAST_ID", "Sync the podcast."
    def sync(podcast_id)
      result = Pod::Commands::Sync::Runner.call(podcast_id)

      puts Pod::Commands::Sync::Output.call(result)
    end

    desc "update PODCAST_ID", "Update the podcast attributes."
    method_option :feed, type: :string, default: "", desc: "Define the podcast feed."
    def update(podcast_id)
      result = Pod::Commands::Update::Runner.call(podcast_id, options)

      puts Pod::Commands::Update::Output.call(result)
    end
  end
end
