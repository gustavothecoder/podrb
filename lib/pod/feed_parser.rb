# frozen_string_literal: true

require "net/http"
require "feedjira"

require_relative "infrastructure/dto"

module Pod
  module FeedParser
    def self.call(feed)
      content = if File.exist?(feed)
        File.new(feed).read
      else
        Net::HTTP.get(URI(feed))
      end
      parsed_content = Feedjira.parse(content)

      podcast = Infrastructure::DTO.new(
        name: parsed_content.title,
        description: parsed_content.description,
        feed: parsed_content.itunes_new_feed_url,
        website: parsed_content.url
      )

      episodes = parsed_content.entries.map do |e|
        Infrastructure::DTO.new(
          title: e.title,
          release_date: e.published.iso8601,
          duration: e.itunes_duration,
          link: e.url,
          external_id: e.entry_id
        )
      end

      # The #reverse is necessary to put the oldest episodes on the top of the feed.
      Infrastructure::DTO.new(podcast: podcast, episodes: episodes.reverse)
    rescue NoMethodError
      Infrastructure::DTO.new(podcast: nil, episodes: nil)
    end
  end
end
