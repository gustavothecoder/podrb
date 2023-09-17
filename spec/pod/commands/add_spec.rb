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
        added_episodes = @db.query("select * from episodes")

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
        expected_episodes = TestHelpers::Data.soft_skills_engineering_episodes
        expect(
          added_episodes
        ).to eq([
          [
            1,
            expected_episodes[0][:title],
            expected_episodes[0][:description],
            expected_episodes[0][:release_date],
            expected_episodes[0][:duration],
            expected_episodes[0][:link],
            added_podcast[0] # podcast_id
          ],
          [
            2,
            expected_episodes[1][:title],
            expected_episodes[1][:description],
            expected_episodes[1][:release_date],
            expected_episodes[1][:duration],
            expected_episodes[1][:link],
            added_podcast[0] # podcast_id
          ],
          [
            3,
            expected_episodes[2][:title],
            expected_episodes[2][:description],
            expected_episodes[2][:release_date],
            expected_episodes[2][:duration],
            expected_episodes[2][:link],
            added_podcast[0] # podcast_id
          ]
        ])
      end
    end

    context "when the podcast already was added" do
      it "returns a success response, but does create DB records" do
        podcast_feed = "spec/fixtures/soft_skills_engineering.xml"

        described_class.call(podcast_feed)
        result = described_class.call(podcast_feed)
        number_of_podcasts = @db.query("select count(id) from podcasts")[0][0]
        number_of_episodes = @db.query("select count(id) from episodes")[0][0]

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:already_added)
        expect(number_of_podcasts).to eq(1)
        expect(number_of_episodes).to eq(3)
      end
    end

    context "when the podcast data is badly formatted" do
      it "returns a failure response and does not create DB records" do
        podcast_feed = "spec/fixtures/podcast_data_badly_formatted.xml"

        result = described_class.call(podcast_feed)
        number_of_podcasts = @db.query("select count(id) from podcasts")[0][0]
        number_of_episodes = @db.query("select count(id) from episodes")[0][0]

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:badly_formatted)
        expect(number_of_podcasts).to be_zero
        expect(number_of_episodes).to be_zero
      end
    end
  end
end
