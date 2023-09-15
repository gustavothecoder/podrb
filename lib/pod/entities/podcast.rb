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

      attr_reader :name, :description, :feed, :website
    end
  end
end
