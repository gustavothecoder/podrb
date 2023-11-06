# frozen_string_literal: true

require_relative "../../support/test_helpers"

RSpec.describe Pod::Commands::Delete do
  describe "#call", :init_pod do
    context "when the podcast is found", :populate_db do
      it "delete the podcast and its episodes" do
        db = Infrastructure::Storage::SQL.new(db: TestHelpers::Path.db_dir)

        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:podcast_deleted)
        episodes = db.query("select id from episodes where podcast_id = 1")
        podcast = db.query("select id from podcasts where id = 1")
        expect(episodes).to be_empty
        expect(podcast).to be_empty
      end
    end

    context "when the podcast is not found" do
      it "returns a failure response" do
        result = described_class.call(1)

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:not_found)
      end
    end
  end
end
