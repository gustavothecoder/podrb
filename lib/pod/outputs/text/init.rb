# frozen_string_literal: true

module Pod
  module Outputs
    module Text
      class Init < ::Pod::Commands::BaseOutput
        def call
          case @context[:details]
          when :already_initialized
            <<~OUTPUT
              Pod already was initialized!
            OUTPUT
          when :successfully_initialized
            <<~OUTPUT
              Pod successfully initialized!
            OUTPUT
          when :home_not_found
            <<~OUTPUT
              It seems that $HOME is empty. Is your home directory set up correctly?
            OUTPUT
          when :cannot_create_initial_config
            <<~OUTPUT
              Pod couldn't create the config files.
            OUTPUT
          end
        end
      end
    end
  end
end
