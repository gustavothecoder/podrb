# frozen_string_literal: true

module Podrb
  module Commands
    module Archive
      class Output < ::Podrb::Commands::BaseOutput
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
