# frozen_string_literal: true

require_relative "../../../support/test_helpers"

RSpec.describe Podrb::Commands::Sync::Runner do
  describe "#call", :init_podrb do
    context "when there are new episodes", :populate_db do
      it "returns a success response and create records for the new episodes" do
        db = Infrastructure::Storage::SQL.new(db: TestHelpers::Path.db_dir)

        before_episode_titles = db.query(
          "select title from episodes where podcast_id = 1"
        ).map { |d| d.title }
        expected_before_episode_titles = TestHelpers::Data
          .soft_skills_engineering_episodes
          .map { |e| e[:title] }
        expect(before_episode_titles).to eq(expected_before_episode_titles)

        allow(
          Net::HTTP
        ).to receive(:get)
          .with(URI("https://softskills.audio/feed.xml"))
          .and_return(File.new("spec/fixtures/soft_skills_engineering_new_eps.xml").read)
        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:podcast_synchronized)
        after_episode_titles = db.query(
          "select title from episodes where podcast_id = 1"
        ).map { |d| d.title }
        expected_after_episode_titles = TestHelpers::Data
          .all_soft_skills_engineering_episodes
          .map { |e| e[:title] }
        expect(after_episode_titles).to eq(expected_after_episode_titles)
      end
    end

    context "when the podcast is already up to date", :populate_db do
      it "returns a success response, but does not create any records" do
        db = Infrastructure::Storage::SQL.new(db: TestHelpers::Path.db_dir)

        before_episode_titles = db.query(
          "select title from episodes where podcast_id = 1"
        ).map { |d| d.title }

        allow(
          Net::HTTP
        ).to receive(:get)
          .with(URI("https://softskills.audio/feed.xml"))
          .and_return(File.new("spec/fixtures/soft_skills_engineering.xml").read)
        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:podcast_synchronized)
        after_episode_titles = db.query(
          "select title from episodes where podcast_id = 1"
        ).map { |d| d.title }
        expect(after_episode_titles).to eq(before_episode_titles)
      end
    end

    context "when the podcast is not found" do
      it "returns a failure response and does not create any records" do
        result = described_class.call(1)

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:not_found)
      end
    end
  end
end
