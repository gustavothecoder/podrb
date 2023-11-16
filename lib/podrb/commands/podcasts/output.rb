# frozen_string_literal: true

module Podrb
  module Commands
    module Podcasts
      class Output < ::Podrb::Commands::BaseOutput
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
          when :invalid_column
            <<~OUTPUT
              This field is invalid: #{@context[:metadata][:invalid_column]}
            OUTPUT
          end
        end
      end
    end
  end
end
