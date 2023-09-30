# frozen_string_literal: true

module Pod
  module Outputs
    module Text
      class Open < ::Pod::Outputs::Base
        def call
          case @context[:details]
          when :not_found
            <<~OUTPUT
              The episode was not found.
            OUTPUT
          end
        end
      end
    end
  end
end
