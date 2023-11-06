# frozen_string_literal: true

require_relative "../../support/test_helpers"

RSpec.describe Pod::Commands::Dearchive do
  describe "#call", :init_pod do
    context "when episode is found", :populate_db do
      it "dearchive the episode and returns a success response" do
        db = Infrastructure::Storage::SQL.new(db: TestHelpers::Path.db_dir)

        Pod::Commands::Archive::Runner.call(1)
        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:episode_dearchived)
        after_archived_at = db.query(
          "select archived_at from episodes where id = 1;"
        )[0]["archived_at"]
        expect(after_archived_at).to be_nil
      end
    end

    context "when episode is not found" do
      it "returns a failure response" do
        result = described_class.call(1)

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:not_found)
      end
    end
  end
end
