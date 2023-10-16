# frozen_string_literal: true

RSpec.describe Pod::Outputs::Text::Episodes do
  describe "#call" do
    context "when records are found" do
      it "generates the correct message" do
        response = described_class.new(
          status: :success,
          details: :records_found,
          metadata: {
            records: [
              Infrastructure::DTO.new(
                id: 1,
                title: "001",
                release_date: "2023/09/24",
                duration: "00:34:09",
                link: "https://pod1.com/ep1"
              ),
              Infrastructure::DTO.new(
                id: 2,
                title: "002",
                release_date: "2023/09/25",
                duration: "00:17:17",
                link: "https://pod1.com/ep2"
              )
            ],
            columns: %w[id title release_date duration link]
          }
        )
        expected_output = <<~OUTPUT
          +----+-------+--------------+----------+----------------------+
          | id | title | release_date | duration |         link         |
          +----+-------+--------------+----------+----------------------+
          |  1 | 001   | 2023/09/24   | 00:34:09 | https://pod1.com/ep1 |
          +----+-------+--------------+----------+----------------------+
          |  2 | 002   | 2023/09/25   | 00:17:17 | https://pod1.com/ep2 |
          +----+-------+--------------+----------+----------------------+
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when records are found, but some attributes are nil" do
      it "generates the correct message" do
        response = described_class.new(
          status: :success,
          details: :records_found,
          metadata: {
            records: [
              Infrastructure::DTO.new(
                id: nil,
                title: "001",
                release_date: nil,
                duration: "00:34:09",
                link: "https://pod1.com/ep1"
              ),
              Infrastructure::DTO.new(
                id: nil,
                title: "002",
                release_date: nil,
                duration: "00:17:17",
                link: "https://pod1.com/ep2"
              )
            ],
            columns: %w[title duration link]
          }
        )
        expected_output = <<~OUTPUT
          +-------+----------+----------------------+
          | title | duration |         link         |
          +-------+----------+----------------------+
          | 001   | 00:34:09 | https://pod1.com/ep1 |
          +-------+----------+----------------------+
          | 002   | 00:17:17 | https://pod1.com/ep2 |
          +-------+----------+----------------------+
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when no records are found" do
      it "generates the correct message" do
        response = described_class.new(
          status: :success,
          details: :not_found,
          metadata: {
            records: [],
            columns: %w[title release_date duration link]
          }
        )
        expected_output = <<~OUTPUT
          No episodes was found.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when the user select a invalid column" do
      it "generates the correct message" do
        response = described_class.new(
          status: :failure,
          details: :invalid_column,
          metadata: {
            invalid_column: "name"
          }
        )
        expected_output = <<~OUTPUT
          This field is invalid: name
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end
