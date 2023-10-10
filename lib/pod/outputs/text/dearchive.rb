# frozen_string_literal: true

module Pod
  module Outputs
    module Text
      class Dearchive < ::Pod::Outputs::Base
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
