# frozen_string_literal: true

module Pod
  module Outputs
    class Base
      def initialize(context = {})
        @context = context
      end

      private

      def failure?
        @context[:status] == :failure
      end

      def success?
        @context[:status] == :success
      end
    end
  end
end
