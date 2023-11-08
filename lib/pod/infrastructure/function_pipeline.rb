# frozen_string_literal: true

module Infrastructure
  class FunctionPipeline
    def initialize(functions:, on_error:, context: {})
      @functions = functions
      @on_error = on_error
      @context = Context.new(context)
    end

    def call
      @functions.each { |f| f.call(@context) }
    rescue => e
      @context[:error] = e
      @on_error.call(@context)
    ensure
      return @context.last_entry # standard:disable Lint/EnsureReturn
    end

    private

    class Context
      def initialize(context)
        @state = context
      end

      def [](key)
        @state[key.to_sym]
      end

      def []=(key, value)
        @state[key.to_sym] = value
        @state[:last_entry] = key
      end

      def last_entry
        key = @state[:last_entry]
        @state[key]
      end
    end
  end
end
