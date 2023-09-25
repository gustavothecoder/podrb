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

      def self.batch_initialize(batch)
        batch.map do |p|
          new(p[0], p[1], p[2], p[3])
        end
      end

      attr_reader :name, :description, :feed, :website
    end
  end
end
