# frozen_string_literal: true

module Pod
  module Entities
    class Episode
      def initialize(title: nil, release_date: nil, duration: nil, link: nil)
        @title = title
        @release_date = release_date
        @duration = duration
        @link = link
      end

      attr_reader :title, :release_date, :duration, :link
    end
  end
end
