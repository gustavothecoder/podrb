# frozen_string_literal: true

module Pod
  module Outputs
    module Text
      class Archive < ::Pod::Outputs::Base
        def call
          case @context[:details]
          when :episode_archived
            <<~OUTPUT
              Episode successfully archived!
            OUTPUT
          when :not_found
            <<~OUTPUT
              Episode not found
            OUTPUT
          end
        end
      end
    end
  end
end
