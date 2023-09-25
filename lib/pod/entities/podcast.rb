# frozen_string_literal: true

module Pod
  module Entities
    class Podcast
      def initialize(id: nil, name: nil, description: nil, feed: nil, website: nil)
        @id = id
        @name = name
        @description = description
        @feed = feed
        @website = website
      end

      attr_reader :id, :name, :description, :feed, :website
    end
  end
end
