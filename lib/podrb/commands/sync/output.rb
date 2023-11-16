# frozen_string_literal: true

module Podrb
  module Commands
    module Sync
      class Output < ::Podrb::Commands::BaseOutput
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
