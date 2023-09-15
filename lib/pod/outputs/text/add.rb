# frozen_string_literal: true

module Pod
  module Outputs
    module Text
      class Add < ::Pod::Outputs::Base
        def call
          case @context[:details]
          when :successfully_added
            <<~OUTPUT
              Podcast successfully added to the database!
            OUTPUT
          when :already_added
            <<~OUTPUT
              Podcast already exists in the database.
            OUTPUT
          when :badly_formatted
            <<~OUTPUT
              The podcast feed is badly formatted or unsupported.
            OUTPUT
          end
        end
      end
    end
  end
end
