# frozen_string_literal: true

module Pod
  module Entities
    class Episode
      def initialize(id: nil, title: nil, release_date: nil, duration: nil, link: nil, external_id: nil)
        @id = id
        @title = title
        @release_date = release_date
        @duration = duration
        @link = link
        @external_id = external_id
      end

      attr_reader :id, :title, :release_date, :duration, :link, :external_id
    end
  end
end
