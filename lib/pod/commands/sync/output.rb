# frozen_string_literal: true

module Pod
  module Commands
    module Sync
      class Output < ::Pod::Commands::BaseOutput
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
