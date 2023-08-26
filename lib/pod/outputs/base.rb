# frozen_string_literal: true

module Pod
  module Outputs
    class Base
      def initialize(context = {})
        @context = context
      end
    end
  end
end
