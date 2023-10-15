# frozen_string_literal: true

RSpec.describe Pod::Outputs::Text::Update do
  describe "#call" do
    context "when podcast was updated" do
      it "generates the correct message" do
        response = described_class.new(status: :success, details: :podcast_updated)
        expected_output = <<~OUTPUT
          Podcast successfully updated!
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when invalid options were passed" do
      it "generates the correct message" do
        response = described_class.new(status: :failure, details: :invalid_options)
        expected_output = <<~OUTPUT
          Invalid options. Check the documentation `pod help update`.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when the podcast were not found" do
      it "generates the correct message" do
        response = described_class.new(status: :failure, details: :not_found)
        expected_output = <<~OUTPUT
          Podcast not found.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end
