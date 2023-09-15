# frozen_string_literal: true

module Pod
  module Entities
    class Feed
      def initialize(podcast)
        @podcast = podcast
      end

      attr_reader :podcast
    end
  end
end
