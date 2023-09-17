# frozen_string_literal: true

module Pod
  module Entities
    class Feed
      def initialize(podcast, episodes)
        @podcast = podcast
        @episodes = episodes
      end

      attr_reader :podcast, :episodes
    end
  end
end
