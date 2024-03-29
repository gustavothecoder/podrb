# frozen_string_literal: true

module Podrb
  module Commands
    module Delete
      class Output < ::Podrb::Commands::BaseOutput
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
