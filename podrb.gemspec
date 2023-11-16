# frozen_string_literal: true

require_relative "lib/podrb/version"

Gem::Specification.new do |spec|
  spec.name = "podrb"
  spec.version = Podrb::VERSION
  spec.authors = ["Gustavo Ribeiro"]
  spec.email = ["grdev@tutanota.com"]

  spec.summary = "Minimalist CLI to manage podcasts"
  spec.homepage = "https://github.com/gustavothecoder/podrb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/gustavothecoder/podrb/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("lib/podrb{.rb,/**/*}")
  spec.bindir = "exe"
  spec.executables = ["podrb"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.2"
  spec.add_dependency "feedjira", "~> 3.2"
  spec.add_dependency "sqlite3", "~> 1.5"
  spec.add_dependency "tabulo", "~> 2.8"
end
