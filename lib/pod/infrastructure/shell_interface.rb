# frozen_string_literal: true

module Infrastructure
  module ShellInterface
    def self.call(args)
      return if args.nil? || args[:cmd].nil?

      `#{args[:cmd]}`
    end
  end
end
