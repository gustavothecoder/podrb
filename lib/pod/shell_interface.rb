# frozen_string_literal: true

module Pod
  module ShellInterface
    def self.call(args)
      return if args.nil? || args[:cmd].nil?

      `#{args[:cmd]}`
    end
  end
end
