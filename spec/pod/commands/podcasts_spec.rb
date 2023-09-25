# frozen_string_literal: true

require_relative "../../support/test_helpers"

RSpec.describe Pod::Commands::Podcasts do
  describe  "#call", :init_pod do
    context "when there are podcasts", :populate_db do
      it "returns a success response with the table records" do
        result = described_class.call

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:records_found)
        expected_podcast1 = TestHelpers::Data.soft_skills_engineering
        expected_podcast2 = TestHelpers::Data.fabio_akita
        result_podcast1 = result[:data][0]
        result_podcast2 = result[:data][1]
        expect(result_podcast1.name).to eq(expected_podcast1[:name])
        expect(result_podcast1.description).to eq(expected_podcast1[:description])
        expect(result_podcast1.feed).to eq(expected_podcast1[:feed])
        expect(result_podcast1.website).to eq(expected_podcast1[:website])
        expect(result_podcast2.name).to eq(expected_podcast2[:name])
        expect(result_podcast2.description).to eq(expected_podcast2[:description])
        expect(result_podcast2.feed).to eq(expected_podcast2[:feed])
        expect(result_podcast2.website).to eq(expected_podcast2[:website])
      end
    end

    context "when there are no podcasts" do
      it "returns a success response without data" do
        result = described_class.call

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:empty_table)
        expect(result[:data]).to eq([])
      end
    end
  end
end
