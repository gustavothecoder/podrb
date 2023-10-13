# frozen_string_literal: true

RSpec.describe Pod::Outputs::Text::Sync do
  describe "#call" do
    context "when the podcast is successfully synchronized" do
      it "generates the correct message" do
        response = described_class.new(status: :success, details: :podcast_synchronized)
        expected_output = <<~OUTPUT
          Podcast successfully synchronized!
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when the podcast is not found" do
      it "generates the correct message" do
        response = described_class.new(status: :success, details: :not_found)
        expected_output = <<~OUTPUT
          Podcast not found
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end
