# frozen_string_literal: true

RSpec.describe Pod::Outputs::Text::Delete do
  describe "#call" do
    context "when podcast was deleted" do
      it "generates the correct message" do
        response = described_class.new(status: :success, details: :podcast_deleted)
        expected_output = <<~OUTPUT
          Podcast successfully deleted!
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when podcast was not found" do
      it "generates the correct message" do
        response = described_class.new(status: :failure, details: :not_found)
        expected_output = <<~OUTPUT
          Podcast not found
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end
