# frozen_string_literal: true

RSpec.describe Pod::Commands::Add::Output do
  describe "#call" do
    context "when the podcast is successfully added" do
      it "generates the correct message" do
        response = described_class.new(status: :success, details: :successfully_added)
        expected_output = <<~OUTPUT
          Podcast successfully added to the database!
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when the podcast already was added" do
      it "generates the correct message" do
        response = described_class.new(status: :failure, details: :already_added)
        expected_output = <<~OUTPUT
          Podcast already exists in the database.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when the podcast feed is badly formatted" do
      it "generates the correct message" do
        response = described_class.new(status: :failure, details: :badly_formatted)
        expected_output = <<~OUTPUT
          The podcast feed is badly formatted or unsupported.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context "when the podcast feed hasn't a sync url" do
      it "generates the correct message" do
        response = described_class.new(status: :failure, details: :missing_sync_url)
        expected_output = <<~OUTPUT
          This podcast feed doesn't provide a sync url. Please, use the --sync-url option to set this data manually.
          Ex: `pod add FEED --sync-url=SYNC_URL`
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end
