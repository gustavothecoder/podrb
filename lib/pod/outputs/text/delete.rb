# frozen_string_literal: true

module Pod
  module Outputs
    module Text
      class Delete < ::Pod::Outputs::Base
        def call
          case @context[:details]
          when :podcast_deleted
            <<~OUTPUT
              Podcast successfully deleted!
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
