# frozen_string_literal: true

RSpec.describe Pod::Outputs::Text::Table do
  describe "#call" do
    context "when there are records to show" do
      it "generates the correct output" do
        response = described_class.new(
          status: :success,
          details: :records_found,
          data: [
            Pod::Entities::Podcast.new("pod1", "pod1", "https://pod1.feed", "https://pod1.com"),
            Pod::Entities::Podcast.new("pod2", "pod2", "https://pod2.feed", "https://pod2.com")
          ]
        )
        expected_output = <<~OUTPUT
          +------+-------------+-------------------+------------------+
          | name | description |        feed       |      website     |
          +------+-------------+-------------------+------------------+
          | pod1 | pod1        | https://pod1.feed | https://pod1.com |
          +------+-------------+-------------------+------------------+
          | pod2 | pod2        | https://pod2.feed | https://pod2.com |
          +------+-------------+-------------------+------------------+
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when there are no records do show" do
      it "generates the correct output" do
        response = described_class.new(
          status: :success,
          details: :empty_table,
          data: []
        )
        expected_output = <<~OUTPUT
          This table has no records.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when the table was not found" do
      it "generates the correct output" do
        response = described_class.new(
          status: :failure,
          details: :invalid_table,
          data: []
        )
        expected_output = <<~OUTPUT
          This table is invalid.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end

