# frozen_string_literal: true

require "tabulo"

module Pod
  module Outputs
    class Base
      def self.call(context = {})
        new(context).call
      end

      def initialize(context)
        @context = context
      end

      private

      def generate_text_table(data:, columns:)
        Tabulo::Table.new(data, *columns.map(&:to_sym), row_divider_frequency: 1).pack
      end
    end
  end
end
