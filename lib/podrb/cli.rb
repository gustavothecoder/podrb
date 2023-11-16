# frozen_string_literal: true

require "thor"

require_relative "commands"
require_relative "infrastructure/storage/sql"
require_relative "infrastructure/shell_interface"

module Podrb
  class CLI < Thor
    # https://github.com/rails/thor/issues/728#issuecomment-642798887
    def self.exit_on_failure?
      true
    end

    def self.start(given_args = ARGV, config = {})
      command = given_args.first
      does_not_require_config = %w[version -V --version init].include?(command)
      podrb_initialized = Dir.exist?(ENV["HOME"] + "/.config/podrb")
      if does_not_require_config || podrb_initialized
        super
      else
        puts "Missing config files. Run `podrb init` first."
      end
    end

    desc "version", "Displays the podrb version"
    map %w[-V --version] => :version
    def version
      puts VERSION
    end

    desc "init", "Creates the podrb config files"
    def init
      puts "Creating config files..."

      result = Podrb::Commands::Init::Runner.call

      puts Podrb::Commands::Init::Output.call(result)
    end

    desc "add FEED", "Adds a podcast to the Podrb database"
    method_option :sync_url, type: :string, default: "", desc: "Podrb will use this URL to sync the podcast."
    def add(feed)
      puts "Adding the podcast..."

      result = Podrb::Commands::Add::Runner.call(feed, options)

      puts Podrb::Commands::Add::Output.call(result)
    end

    desc "podcasts", "List the podcast records"
    method_option :fields, type: :array, default: [], desc: "Select the fields that will be displayed."
    def podcasts
      result = Podrb::Commands::Podcasts::Runner.call(options)

      puts Podrb::Commands::Podcasts::Output.call(result)
    end

    desc "episodes PODCAST_ID", "List the podcast episodes"
    method_option :fields, type: :array, default: [], desc: "Select the fields that will be displayed."
    method_option :order_by, type: :string, default: "id", desc: "Choose how podrb will order the episodes."
    method_option :all, type: :boolean, default: false, desc: "List archived episodes too."
    def episodes(podcast_id)
      result = Podrb::Commands::Episodes::Runner.call(podcast_id, options)

      puts Podrb::Commands::Episodes::Output.call(result)
    end

    desc "open EPISODE_ID", "Open a episode in the browser"
    method_option :browser, type: :string, default: "firefox", desc: "Choose the browser."
    method_option :archive, type: :boolean, default: false, desc: "Archive the episode."
    def open(episode_id)
      result = Podrb::Commands::Open::Runner.call(episode_id, options)

      Infrastructure::ShellInterface.call(result[:metadata])

      puts Podrb::Commands::Open::Output.call(result)
    end

    desc "archive EPISODE_ID", "Archive the episode"
    def archive(episode_id)
      result = Podrb::Commands::Archive::Runner.call(episode_id)

      puts Podrb::Commands::Archive::Output.call(result)
    end

    desc "dearchive EPISODE_ID", "Dearchive the episode."
    def dearchive(episode_id)
      result = Podrb::Commands::Dearchive::Runner.call(episode_id)

      puts Podrb::Commands::Dearchive::Output.call(result)
    end

    desc "delete PODCAST_ID", "Delete the podcast from podrb's database."
    def delete(podcast_id)
      result = Podrb::Commands::Delete::Runner.call(podcast_id)

      puts Podrb::Commands::Delete::Output.call(result)
    end

    desc "sync PODCAST_ID", "Sync the podcast."
    def sync(podcast_id)
      result = Podrb::Commands::Sync::Runner.call(podcast_id)

      puts Podrb::Commands::Sync::Output.call(result)
    end

    desc "update PODCAST_ID", "Update the podcast attributes."
    method_option :feed, type: :string, default: "", desc: "Define the podcast feed."
    def update(podcast_id)
      result = Podrb::Commands::Update::Runner.call(podcast_id, options)

      puts Podrb::Commands::Update::Output.call(result)
    end
  end
end
