# frozen_string_literal: true

require_relative "../../../support/test_helpers"

RSpec.describe Podrb::Commands::Archive::Runner do
  describe "#call", :init_podrb do
    context "when episode is found", :populate_db do
      it "archive the episode and returns a success response" do
        current_date = Time.now.iso8601
        db = Infrastructure::Storage::SQL.new(db: TestHelpers::Path.db_dir)

        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:episode_archived)
        after_archived_at = db.query(
          "select archived_at from episodes where id = 1;"
        )[0].archived_at
        expect(after_archived_at).to eq(current_date)
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
