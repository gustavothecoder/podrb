# frozen_string_literal: true

module Pod
  module Entities
    class Podcast
      def initialize(name, description, feed, website)
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
