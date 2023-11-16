# frozen_string_literal: true

module Infrastructure
  class DTO
    def initialize(attrs)
      @attrs = attrs
    end

    def respond_to_missing?(symbol, include_private = false)
      @attrs.key?(symbol) || super
    end

    def method_missing(symbol, *args)
      @attrs[symbol]
    end
  end
end
