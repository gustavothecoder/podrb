# frozen_string_literal: true

require_relative "../../../support/test_helpers"

RSpec.describe Podrb::Commands::Open::Runner do
  describe "#call", :init_podrb do
    context "when the episode exist", :populate_db do
      it "returns a success response" do
        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:episode_found)
        expect(result[:metadata][:cmd]).to eq(
          "firefox #{TestHelpers::Data.soft_skills_engineering_episodes[0][:link]}"
        )
      end
    end

    context "when the episode does not exist" do
      it "returns a failure response" do
        result = described_class.call(1)

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:not_found)
        expect(result[:metadata]).to be_nil
      end
    end

    context "when the browser option is used", :populate_db do
      it "returns a success response using the browser option" do
        result = described_class.call(1, {"browser" => "brave"})

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:episode_found)
        expect(result[:metadata][:cmd]).to eq(
          "brave #{TestHelpers::Data.soft_skills_engineering_episodes[0][:link]}"
        )
      end
    end

    context "when the archive option is used", :populate_db do
      it "returns a success response using the archive option" do
        result = described_class.call(1, {"archive" => true})

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:episode_found)
        expect(result[:metadata][:cmd]).to eq(
          "firefox #{TestHelpers::Data.soft_skills_engineering_episodes[0][:link]}" \
          " && bundle exec podrb archive 1"
        )
      end
    end
  end
end
