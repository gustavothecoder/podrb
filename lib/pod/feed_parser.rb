# frozen_string_literal: true

require "net/http"
require "feedjira"

require_relative "entities"

module Pod
  module FeedParser
    def self.call(feed)
      content = if File.exist?(feed)
        File.new(feed).read
      else
        Net::HTTP.get(URI(feed))
      end
      parsed_content = Feedjira.parse(content)

      podcast = Pod::Entities::Podcast.new(
        name: parsed_content.title,
        description: parsed_content.description,
        feed: parsed_content.itunes_new_feed_url,
        website: parsed_content.url
      )

      episodes = parsed_content.entries.map do |e|
        Pod::Entities::Episode.new(
          title: e.title,
          release_date: e.published.iso8601,
          duration: e.itunes_duration,
          link: e.url,
          external_id: e.entry_id
        )
      end

      # The #reverse is necessary to put the oldest episodes on the top of the feed.
      Pod::Entities::Feed.new(podcast, episodes.reverse)
    rescue NoMethodError
      Pod::Entities::Feed.new(nil, nil)
    end
  end
end
