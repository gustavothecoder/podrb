# frozen_string_literal: true

module Pod
  module Commands
    class Base
      def self.call(*args)
        command = new
        if command.method(:call).parameters.empty?
          command.call
        else
          command.call(*args)
        end
      end

      private

      def build_success_response(details:)
        {status: :success, details: details}
      end

      def build_failure_response(details:)
        {status: :failure, details: details}
      end
    end
  end
end
