# frozen_string_literal: true

module Pod
  module Outputs
    module Text
      class Sync < ::Pod::Outputs::Base
        def call
          case @context[:details]
          when :podcast_synchronized
            <<~OUTPUT
              Podcast successfully synchronized!
            OUTPUT
          when :not_found
            <<~OUTPUT
              Podcast not found
            OUTPUT
          end
        end
      end
    end
  end
end
