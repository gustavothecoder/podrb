# frozen_string_literal: true

module Pod
  module Commands
    module Update
      class Output < ::Pod::Commands::BaseOutput
        def call
          case @context[:details]
          when :podcast_updated
            <<~OUTPUT
              Podcast successfully updated!
            OUTPUT
          when :invalid_options
            <<~OUTPUT
              Invalid options. Check the documentation `pod help update`.
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