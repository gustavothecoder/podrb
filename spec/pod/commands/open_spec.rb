# frozen_string_literal: true

require_relative "../../support/test_helpers"

RSpec.describe Pod::Commands::Open do
  describe "#call", :init_pod do
    context "when the episode exist", :populate_db do
      it "returns a success response" do
        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:can_open)
        expect(result[:metadata][:cmd]).to eq(
          "/usr/bin/firefox https://softskills.audio/2016/03/21/episode-3-what-to-look-for-in-a-dev-team/"
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
  end
end
