# frozen_string_literal: true

require_relative "../../support/test_helpers"

RSpec.describe Pod::Commands::Update do
  describe "#call", :init_pod do
    context "when valid options are received and the podcast exists", :populate_db do
      it "returns a success response and updates the podcast" do
        db = Infrastructure::Storage::SQL.new(db: TestHelpers::Path.db_dir)
        before_podcast = db.query("select * from podcasts").first

        result = described_class.call(1, {"feed" => "https://www.newfeed.com"})

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:podcast_updated)
        after_podcast = db.query("select * from podcasts").first
        expect(before_podcast.id).to eq(after_podcast.id)
        expect(before_podcast.name).to eq(after_podcast.name)
        expect(before_podcast.description).to eq(after_podcast.description)
        expect(before_podcast.feed).to_not eq(after_podcast.feed)
        expect(after_podcast.feed).to eq("https://www.newfeed.com")
        expect(before_podcast.website).to eq(after_podcast.website)
      end
    end

    context "when invalid options are received", :populate_db do
      it "returns a failure response and does not updates the podcast" do
        db = Infrastructure::Storage::SQL.new(db: TestHelpers::Path.db_dir)
        before_podcast = db.query("select * from podcasts").first

        result = described_class.call(1, {"feed" => ""})

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:invalid_options)
        after_podcast = db.query("select * from podcasts").first
        expect(before_podcast.id).to eq(after_podcast.id)
        expect(before_podcast.name).to eq(after_podcast.name)
        expect(before_podcast.description).to eq(after_podcast.description)
        expect(before_podcast.feed).to eq(after_podcast.feed)
        expect(before_podcast.website).to eq(after_podcast.website)
      end
    end

    context "when the podcast is not found" do
      it "returns a failure response and does not updates the podcast" do
        result = described_class.call(1, {"feed" => "https://www.newfeed.com"})

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:not_found)
      end
    end
  end
end
