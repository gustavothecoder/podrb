# frozen_string_literal: true

module Podrb
  module Commands
    module Init
      class Output < ::Podrb::Commands::BaseOutput
        def call
          case @context[:details]
          when :already_initialized
            <<~OUTPUT
              Podrb already was initialized!
            OUTPUT
          when :successfully_initialized
            <<~OUTPUT
              Podrb successfully initialized!
            OUTPUT
          when :home_not_found
            <<~OUTPUT
              It seems that $HOME is empty. Is your home directory set up correctly?
            OUTPUT
          when :cannot_create_initial_config
            <<~OUTPUT
              Podrb couldn't create the config files.
            OUTPUT
          end
        end
      end
    end
  end
end
