# frozen_string_literal: true

RSpec.describe Pod::Outputs::Text::Dearchive do
  describe "#call" do
    context "when episode was dearchived" do
      it "generates the correct message" do
        response = described_class.new(status: :success, details: :episode_dearchived)
        expected_output = <<~OUTPUT
          Episode successfully dearchived!
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
