# frozen_string_literal: true

require_relative "../support/test_helpers"

RSpec.describe Pod::FeedParser do
  describe "#call" do
    context "when the feed is successfully parsed" do
      it "returns a feed entity with the expected data" do
        podcast_feed = %w[https://softskills.audio/feed.xml spec/fixtures/soft_skills_engineering.xml].sample
        if podcast_feed.match?(/https/)
          allow(
            Net::HTTP
          ).to receive(:get)
            .with(URI("https://softskills.audio/feed.xml"))
            .and_return(File.new("spec/fixtures/soft_skills_engineering.xml").read)
        end

        result = described_class.call(podcast_feed)

        expect(result).to be_a(Pod::Entities::Feed)
        expected_podcast = TestHelpers::Data.soft_skills_engineering
        expect(result.podcast.name).to eq(expected_podcast[:name])
        expect(result.podcast.description).to eq(expected_podcast[:description])
        expect(result.podcast.feed).to eq(expected_podcast[:feed])
        expect(result.podcast.website).to eq(expected_podcast[:website])
        episodes = result.episodes
        3.times do |i|
          parsed = episodes[i]
          expected = TestHelpers::Data.soft_skills_engineering_episodes[i]
          expect(parsed.title).to eq(expected[:title])
          expect(parsed.release_date).to eq(expected[:release_date])
          expect(parsed.duration).to eq(expected[:duration])
          expect(parsed.link).to eq(expected[:link])
        end
      end
    end

    context "when the feed content is badly formatted" do
      it "returns a feed object without data" do
        podcast_feed = %w[
          https://softskills.audio/feed.xml
          spec/fixtures/podcast_data_badly_formatted.xml
        ].sample
        if podcast_feed.match?(/https/)
          allow(
            Net::HTTP
          ).to receive(:get)
            .with(URI("https://softskills.audio/feed.xml"))
            .and_return(File.new("spec/fixtures/podcast_data_badly_formatted.xml").read)
        end

        result = described_class.call(podcast_feed)

        expect(result).to be_a(Pod::Entities::Feed)
        expect(result.podcast).to be_nil
      end
    end
  end
end
