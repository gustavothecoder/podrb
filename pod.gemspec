# frozen_string_literal: true

require_relative "lib/pod/version"

Gem::Specification.new do |spec|
  spec.name = "pod"
  spec.version = Pod::VERSION
  spec.authors = ["Gustavo Ribeiro"]
  spec.email = ["g2_ribeiro@hotmail.com"]

  spec.summary = "Minimalist CLI to manage podcasts"
  spec.homepage = "https://github.com/gustavothecoder/pod"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/gustavothecoder/pod/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("lib/pod{.rb,/**/*}")
  spec.bindir = "exe"
  spec.executables = ["pod"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.2"
  spec.add_dependency "feedjira", "~> 3.2"
  spec.add_dependency "sqlite3", "~> 1.5"
  spec.add_dependency "tabulo", "~> 2.8"
end
