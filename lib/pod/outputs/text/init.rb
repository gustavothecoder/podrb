# frozen_string_literal: true

module Pod
  module Outputs
    module Text
      class Init < ::Pod::Outputs::Base
        def call
          case @context[:details]
          when success?, :already_initialized
            <<~OUTPUT
              Pod already was initialized!
            OUTPUT
          when success?, :successfully_initialized
            <<~OUTPUT
              Pod successfully initialized!
            OUTPUT
          when failure?, :home_not_found
            <<~OUTPUT
              It seems that $HOME is empty. Is your home directory set up correctly?
            OUTPUT
          when failure?, :cannot_create_initial_config
            <<~OUTPUT
              Pod couldn't create the config files.
            OUTPUT
          end
        end
      end
    end
  end
end
