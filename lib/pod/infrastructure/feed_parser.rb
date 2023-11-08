# frozen_string_literal: true

require "net/http"
require "feedjira"

require_relative "dto"
require_relative "function_pipeline"

module Infrastructure
  module FeedParser
    def self.call(feed)
      pipeline = FunctionPipeline.new(
        functions: [
          FetchContent,
          ParseContent,
          InitializePodcastDTO,
          InitializeEpisodesDTO,
          InitializeFeedDTO
        ],
        on_error: InitializeEmptyFeedDTO,
        context: {feed: feed}
      )

      pipeline.call
    end

    private

    FetchContent = ->(ctx) do
      feed = ctx[:feed]

      content = if File.exist?(feed)
        File.new(feed).read
      else
        Net::HTTP.get(URI(feed))
      end

      ctx[:content] = content
    end

    ParseContent = ->(ctx) do
      ctx[:parsed_content] = Feedjira.parse(ctx[:content])
    end

    InitializePodcastDTO = ->(ctx) do
      parsed_content = ctx[:parsed_content]
      ctx[:podcast] = Infrastructure::DTO.new(
        name: parsed_content.title,
        description: parsed_content.description,
        feed: parsed_content.itunes_new_feed_url,
        website: parsed_content.url
      )
    end

    InitializeEpisodesDTO = ->(ctx) do
      parsed_content = ctx[:parsed_content]
      ctx[:episodes] = parsed_content.entries.map do |e|
        Infrastructure::DTO.new(
          title: e.title,
          release_date: e.published.iso8601,
          duration: e.itunes_duration,
          link: e.url,
          external_id: e.entry_id
        )
      end
    end

    InitializeFeedDTO = ->(ctx) do
      podcast = ctx[:podcast]
      episodes = ctx[:episodes]
      # The #reverse is necessary to put the oldest episodes on the top of the feed.
      ctx[:feed] = Infrastructure::DTO.new(podcast: podcast, episodes: episodes.reverse)
    end

    InitializeEmptyFeedDTO = ->(ctx) do
      ctx[:feed] = Infrastructure::DTO.new(podcast: nil, episodes: nil)
    end
  end
end
