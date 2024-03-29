# frozen_string_literal: true

module Podrb
  module Commands
    module Dearchive
      class Output < ::Podrb::Commands::BaseOutput
        def call
          case @context[:details]
          when :episode_dearchived
            <<~OUTPUT
              Episode successfully dearchived!
            OUTPUT
          when :not_found
            <<~OUTPUT
              Episode not found
            OUTPUT
          end
        end
      end
    end
  end
end
