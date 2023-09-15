# frozen_string_literal: true

require_relative "../../support/test_helpers"

RSpec.describe Pod::Commands::Add do
  before do
    @db = Pod::Storage::SQL.new(db: TestHelpers::Path.db_dir)
  end

  describe "call", :init_pod do
    context "when feed is valid" do
      it "returns a success response and adds the podcast feed to the database" do
        podcast_feed = "spec/fixtures/soft_skills_engineering.xml"

        result = described_class.call(podcast_feed)
        added_podcast = @db.query("select * from podcasts").first

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:successfully_added)
        expect(
          added_podcast
        ).to eq([
          1,
          "Soft Skills Engineering",
          "It takes more than great code to be a great engineer. " \
          "Soft Skills Engineering is a weekly advice podcast for software developers " \
          "about the non-technical stuff that goes into being a great software developer.",
          "https://softskills.audio/feed.xml",
          "https://softskills.audio/"
        ])
      end
    end

    context "when the podcast already was added" do
      it "returns a success response, but does not adds the podcast to the database" do
        podcast_feed = "spec/fixtures/soft_skills_engineering.xml"

        described_class.call(podcast_feed)
        result = described_class.call(podcast_feed)
        number_of_podcasts = @db.query("select * from podcasts").size

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:already_added)
        expect(number_of_podcasts).to eq(1)
      end
    end

    context "when the feed is badly formatted" do
      it "returns a failure response and does not adds the podcast to the database" do
        podcast_feed = "spec/fixtures/badly_formatted_soft_skills_engineering.xml"

        result = described_class.call(podcast_feed)
        number_of_podcasts = @db.query("select * from podcasts").size

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:badly_formatted)
        expect(number_of_podcasts).to be_zero
      end
    end
  end
end
