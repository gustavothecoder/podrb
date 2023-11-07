# frozen_string_literal: true

RSpec.describe Pod::Commands::Archive::Output do
  describe "#call" do
    context "when episode was archived" do
      it "generates the correct message" do
        response = described_class.new(status: :success, details: :episode_archived)
        expected_output = <<~OUTPUT
          Episode successfully archived!
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when episode was not found" do
      it "generates the correct message" do
        response = described_class.new(status: :failure, details: :not_found)
        expected_output = <<~OUTPUT
          Episode not found
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end
