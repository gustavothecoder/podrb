# frozen_string_literal: true

module Pod
  module Outputs
    module Text
      class Podcasts < ::Pod::Outputs::Base
        def call
          case @context[:details]
          when :records_found
            text_table = generate_text_table(
              data: @context[:metadata][:records],
              columns: @context[:metadata][:columns]
            )
            <<~OUTPUT
              #{text_table}
            OUTPUT
          when :empty_table
            <<~OUTPUT
              No podcasts yet.
            OUTPUT
          end
        end
      end
    end
  end
end
