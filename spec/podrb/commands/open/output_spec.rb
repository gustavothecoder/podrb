# frozen_string_literal: true

RSpec.describe Podrb::Commands::Open::Output do
  describe "#call" do
    context "when the episode was not found" do
      it "generates the correct output" do
        response = described_class.new(
          status: :failure,
          details: :not_found,
          metadata: nil
        )
        expected_output = <<~OUTPUT
          The episode was not found.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end
