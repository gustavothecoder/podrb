# frozen_string_literal: true

module Pod
  module Entities
    class Podcast
      def initialize(name: nil, description: nil, feed: nil, website: nil)
        @name = name
        @description = description
        @feed = feed
        @website = website
      end

      attr_reader :name, :description, :feed, :website
    end
  end
end
