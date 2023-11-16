# frozen_string_literal: true

require_relative "../../../support/test_helpers"

RSpec.describe Podrb::Commands::Add::Runner do
  before do
    @db = Infrastructure::Storage::SQL.new(db: TestHelpers::Path.db_dir)
  end

  describe "#call", :init_podrb do
    context "when feed is valid" do
      it "returns a success response and adds the podcast feed to the database" do
        podcast_feed = "spec/fixtures/soft_skills_engineering.xml"
        options = {"sync_url" => ""}

        result = described_class.call(podcast_feed, options)
        added_podcast = @db.query("select * from podcasts").first
        added_episodes = @db.query("select * from episodes")

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:successfully_added)
        expected_podcast = TestHelpers::Data.soft_skills_engineering
        expect(added_podcast.id).to eq(1)
        expect(added_podcast.name).to eq(expected_podcast[:name])
        expect(added_podcast.description).to eq(expected_podcast[:description])
        expect(added_podcast.feed).to eq(expected_podcast[:feed])
        expect(added_podcast.website).to eq(expected_podcast[:website])
        expected_episodes = TestHelpers::Data.soft_skills_engineering_episodes
        3.times do |i|
          expect(added_episodes[i].title).to eq(expected_episodes[i][:title])
          expect(added_episodes[i].release_date).to eq(expected_episodes[i][:release_date])
          expect(added_episodes[i].duration).to eq(expected_episodes[i][:duration])
          expect(added_episodes[i].external_id).to eq(expected_episodes[i][:external_id])
          expect(added_episodes[i].link).to eq(expected_episodes[i][:link])
          expect(added_episodes[i].archived_at).to be_nil
          expect(added_episodes[i].podcast_id).to eq(added_podcast.id)
        end
      end
    end

    context "when the --sync-url option is used" do
      it "returns a success response and stores the --sync-url as the podcast feed" do
        podcast_feed = "spec/fixtures/fabio_akita.xml"
        options = {"sync_url" => "https://www.fabio.com/feed.xml"}

        result = described_class.call(podcast_feed, options)
        added_podcast = @db.query("select * from podcasts").first
        added_episodes = @db.query("select * from episodes")

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:successfully_added)
        expected_podcast = TestHelpers::Data.fabio_akita
        expect(added_podcast.id).to eq(1)
        expect(added_podcast.name).to eq(expected_podcast[:name])
        expect(added_podcast.description).to eq(expected_podcast[:description])
        expect(added_podcast.feed).to eq(expected_podcast[:feed])
        expect(added_podcast.website).to eq(expected_podcast[:website])
        expected_episodes = TestHelpers::Data.fabio_akita_episodes
        3.times do |i|
          expect(added_episodes[i].title).to eq(expected_episodes[i][:title])
          expect(added_episodes[i].release_date).to eq(expected_episodes[i][:release_date])
          expect(added_episodes[i].duration).to eq(expected_episodes[i][:duration])
          expect(added_episodes[i].external_id).to eq(expected_episodes[i][:external_id])
          expect(added_episodes[i].link).to eq(expected_episodes[i][:link])
          expect(added_episodes[i].archived_at).to be_nil
          expect(added_episodes[i].podcast_id).to eq(added_podcast.id)
        end
      end
    end

    context "when the podcast already was added" do
      it "returns a success response, but does create DB records" do
        podcast_feed = "spec/fixtures/soft_skills_engineering.xml"
        options = {"sync_url" => ""}

        described_class.call(podcast_feed, options)
        result = described_class.call(podcast_feed, options)
        number_of_podcasts = @db.query("select count(id) as count from podcasts")[0].count
        number_of_episodes = @db.query("select count(id) as count from episodes")[0].count

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:already_added)
        expect(number_of_podcasts).to eq(1)
        expect(number_of_episodes).to eq(3)
      end
    end

    context "when the podcast data is badly formatted" do
      it "returns a failure response and does not create DB records" do
        podcast_feed = "spec/fixtures/podcast_data_badly_formatted.xml"
        options = {"sync_url" => ""}

        result = described_class.call(podcast_feed, options)
        number_of_podcasts = @db.query("select count(id) as count from podcasts")[0].count
        number_of_episodes = @db.query("select count(id) as count from episodes")[0].count

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:badly_formatted)
        expect(number_of_podcasts).to be_zero
        expect(number_of_episodes).to be_zero
      end
    end

    context "when the feed doesn't include a sync url and the --sync-url option isn't used" do
      it "returns a failure response and does not create DB records" do
        podcast_feed = "spec/fixtures/fabio_akita.xml"
        options = {"sync_url" => ""}

        result = described_class.call(podcast_feed, options)
        number_of_podcasts = @db.query("select count(id) as count from podcasts")[0].count
        number_of_episodes = @db.query("select count(id) as count from episodes")[0].count

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:missing_sync_url)
        expect(number_of_podcasts).to be_zero
        expect(number_of_episodes).to be_zero
      end
    end
  end
end
