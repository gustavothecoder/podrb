# frozen_string_literal: true

require "pod"
require "fileutils"

TMP_DIR = (Dir.pwd + "/tmp").freeze

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around :each do |test|
    if !Dir.exist?(TMP_DIR)
      FileUtils.mkdir_p(TMP_DIR)
    end

    ENV["HOME"] = TMP_DIR

    if test.metadata[:init_pod]
      Pod::Commands::Init.call
    end

    test.run

    config_dir = TMP_DIR + "/.config"
    if Dir.exist?(config_dir)
      FileUtils.rm_r(config_dir)
    end
  end
end
