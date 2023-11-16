# frozen_string_literal: true

module Podrb
  module Commands
    module Update
      class Output < ::Podrb::Commands::BaseOutput
        def call
          case @context[:details]
          when :podcast_updated
            <<~OUTPUT
              Podcast successfully updated!
            OUTPUT
          when :invalid_options
            <<~OUTPUT
              Invalid options. Check the documentation `podrb help update`.
            OUTPUT
          when :not_found
            <<~OUTPUT
              Podcast not found.
            OUTPUT
          end
        end
      end
    end
  end
end
