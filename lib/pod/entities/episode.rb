# frozen_string_literal: true

module Pod
  module Entities
    class Episode
      def initialize(id: nil, title: nil, release_date: nil, duration: nil, link: nil)
        @id = id
        @title = title
        @release_date = release_date
        @duration = duration
        @link = link
      end

      attr_reader :id, :title, :release_date, :duration, :link
    end
  end
end
