# frozen_string_literal: true

require_relative "../support/test_helpers"

RSpec.describe Pod::CLI do
  describe "input interpretation" do
    context "when the input is invalid" do
      it "tells the user that the command was not found" do
        result = TestHelpers::CLI.run_cmd("pod invalid")

        expect(result).to eq('Could not find command "invalid".')
      end
    end
  end

  describe "version command" do
    it "returns the pod version" do
      original_result = TestHelpers::CLI.run_cmd("pod version")
      alias_result1 = TestHelpers::CLI.run_cmd("pod -V")
      alias_result2 = TestHelpers::CLI.run_cmd("pod --version")

      expect(original_result).to eq(Pod::VERSION)
      expect(alias_result1).to eq(original_result)
      expect(alias_result2).to eq(original_result)
    end
  end

  describe "init command" do
    it "creates the initial config files" do
      expected_output = <<~OUTPUT
        Creating config files...
        Pod successfully initialized!
      OUTPUT

      result = TestHelpers::CLI.run_cmd("pod init")

      expect(result).to eq(expected_output.chomp)
    end
  end

  describe "add command" do
    it "adds a podcast to the pod database", :init_pod do
      podcast_feed = "spec/fixtures/soft_skills_engineering.xml"
      expected_output = <<~OUTPUT
        Adding the podcast...
        Podcast successfully added to the database!
      OUTPUT

      result = TestHelpers::CLI.run_cmd("pod add #{podcast_feed}")

      expect(result).to eq(expected_output.chomp)
    end
  end
end
