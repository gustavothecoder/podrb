# frozen_string_literal: true

RSpec.describe Pod::Outputs::Text::Podcasts do
  describe "#call" do
    context "when there are records to show" do
      it "generates the correct output" do
        response = described_class.new(
          status: :success,
          details: :records_found,
          metadata: {
            records: [
              Pod::Entities::Podcast.new(
                name: "pod1",
                description: "pod1",
                feed: "https://pod1.feed",
                website: "https://pod1.com"
              ),
              Pod::Entities::Podcast.new(
                name: "pod2",
                description: "pod2",
                feed: "https://pod2.feed",
                website: "https://pod2.com"
              )
            ],
            columns: %w[name description feed website]
          }
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

    context "when the podcasts doesn't have all attributes" do
      it "generates the correct output" do
        response = described_class.new(
          status: :success,
          details: :records_found,
          metadata: {
            records: [
              Pod::Entities::Podcast.new(
                name: "pod1",
                description: nil,
                feed: "https://pod1.feed",
                website: nil
              ),
              Pod::Entities::Podcast.new(
                name: "pod2",
                description: nil,
                feed: "https://pod2.feed",
                website: nil
              )
            ],
            columns: %w[name feed]
          }
        )
        expected_output = <<~OUTPUT
          +------+-------------------+
          | name |        feed       |
          +------+-------------------+
          | pod1 | https://pod1.feed |
          +------+-------------------+
          | pod2 | https://pod2.feed |
          +------+-------------------+
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
          No podcasts yet.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end
