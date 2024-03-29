# frozen_string_literal: true

module Podrb
  module Commands
    module Open
      class Output < ::Podrb::Commands::BaseOutput
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
