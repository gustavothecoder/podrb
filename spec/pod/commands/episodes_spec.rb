# frozen_string_literal: true

require_relative "../../support/test_helpers"

RSpec.describe Pod::Commands::Episodes do
  describe  "#call", :init_pod do
    context "when there are episodes", :populate_db do
      it "returns a success response with the table records" do
        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:records_found)
        expected_episodes = TestHelpers::Data.soft_skills_engineering_episodes
        result_episodes = result[:metadata][:records]
        expect(result_episodes.size).to eq(3)
        3.times do |i|
          expect(result_episodes[i].id).to be_a(Integer)
          expect(result_episodes[i].title).to eq(expected_episodes[i][:title])
          expect(result_episodes[i].release_date).to eq(expected_episodes[i][:release_date])
          expect(result_episodes[i].duration).to eq(expected_episodes[i][:duration])
          expect(result_episodes[i].link).to eq(expected_episodes[i][:link])
        end
      end
    end

    context "when fields parameter is used", :populate_db do
      it "returns a success response using the fields parameter" do
        result = described_class.call(1, {"fields" => %w[title link]})

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:records_found)
        expected_episodes = TestHelpers::Data.soft_skills_engineering_episodes
        result_episodes = result[:metadata][:records]
        expect(result_episodes.size).to eq(3)
        3.times do |i|
          expect(result_episodes[i].id).to be_nil
          expect(result_episodes[i].title).to eq(expected_episodes[i][:title])
          expect(result_episodes[i].release_date).to be_nil
          expect(result_episodes[i].duration).to be_nil
          expect(result_episodes[i].link).to eq(expected_episodes[i][:link])
        end
      end
    end

    context "when fields parameter is used, but the value is invalid", :populate_db do
      it "returns a failure response without data" do
        result = described_class.call(1, {"fields" => %w[name link]})

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:invalid_column)
        expect(result[:metadata][:invalid_column]).to eq("name")
      end
    end

    context "when there are no episodes" do
      it "returns a success response without data" do
        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:not_found)
        expect(result[:metadata][:records]).to eq([])
      end
    end

    context "when order_by parameter is used", :populate_db do
      it "returns a success response using the order_by parameter" do
        result = described_class.call(1, {"order_by" => "id desc"})

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:records_found)
        expected_episodes = TestHelpers::Data.soft_skills_engineering_episodes.reverse
        result_episodes = result[:metadata][:records]
        expect(result_episodes.size).to eq(3)
        3.times do |i|
          expect(result_episodes[i].title).to eq(expected_episodes[i][:title])
          expect(result_episodes[i].release_date).to eq(expected_episodes[i][:release_date])
          expect(result_episodes[i].duration).to eq(expected_episodes[i][:duration])
          expect(result_episodes[i].link).to eq(expected_episodes[i][:link])
        end
      end
    end

    context "when there are archived episodes", :populate_db do
      it "ignores them" do
        Pod::Commands::Archive::Runner.call(3)
        result = described_class.call(1)

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:records_found)
        expected_episodes = TestHelpers::Data.soft_skills_engineering_episodes
        result_episodes = result[:metadata][:records]
        expect(result_episodes.size).to eq(2)
        2.times do |i|
          expect(result_episodes[i].id).to be_a(Integer)
          expect(result_episodes[i].title).to eq(expected_episodes[i][:title])
          expect(result_episodes[i].release_date).to eq(expected_episodes[i][:release_date])
          expect(result_episodes[i].duration).to eq(expected_episodes[i][:duration])
          expect(result_episodes[i].link).to eq(expected_episodes[i][:link])
        end
      end
    end

    context "when there are archived episodes, but the all option is used", :populate_db do
      it "returns all episodes, including the archived ones" do
        Pod::Commands::Archive::Runner.call(3)
        result = described_class.call(1, {"all" => true})

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:records_found)
        expected_episodes = TestHelpers::Data.soft_skills_engineering_episodes
        result_episodes = result[:metadata][:records]
        expect(result_episodes.size).to eq(3)
        3.times do |i|
          expect(result_episodes[i].id).to be_a(Integer)
          expect(result_episodes[i].title).to eq(expected_episodes[i][:title])
          expect(result_episodes[i].release_date).to eq(expected_episodes[i][:release_date])
          expect(result_episodes[i].duration).to eq(expected_episodes[i][:duration])
          expect(result_episodes[i].link).to eq(expected_episodes[i][:link])
        end
      end
    end
  end
end
