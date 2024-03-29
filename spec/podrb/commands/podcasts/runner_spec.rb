# frozen_string_literal: true

require_relative "../../../support/test_helpers"

RSpec.describe Podrb::Commands::Podcasts::Runner do
  describe  "#call", :init_podrb do
    context "when there are podcasts", :populate_db do
      it "returns a success response with the table records" do
        result = described_class.call

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:records_found)
        expected_podcast1 = TestHelpers::Data.soft_skills_engineering
        expected_podcast2 = TestHelpers::Data.fabio_akita
        result_podcast1 = result[:metadata][:records][0]
        result_podcast2 = result[:metadata][:records][1]
        expect(result_podcast1.id).to eq(1)
        expect(result_podcast1.name).to eq(expected_podcast1[:name])
        expect(result_podcast1.description).to eq(expected_podcast1[:description])
        expect(result_podcast1.feed).to eq(expected_podcast1[:feed])
        expect(result_podcast1.website).to eq(expected_podcast1[:website])
        expect(result_podcast2.id).to eq(2)
        expect(result_podcast2.name).to eq(expected_podcast2[:name])
        expect(result_podcast2.description).to eq(expected_podcast2[:description])
        expect(result_podcast2.feed).to eq(expected_podcast2[:feed])
        expect(result_podcast2.website).to eq(expected_podcast2[:website])
        expect(result[:metadata][:columns]).to eq(%w[id name description feed website])
      end
    end

    context "when fields parameter is used", :populate_db do
      it "returns a success response using the fields parameter" do
        result = described_class.call({"fields" => %w[name feed]})

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:records_found)
        expected_podcast1 = TestHelpers::Data.soft_skills_engineering
        expected_podcast2 = TestHelpers::Data.fabio_akita
        result_podcast1 = result[:metadata][:records][0]
        result_podcast2 = result[:metadata][:records][1]
        expect(result_podcast1.name).to eq(expected_podcast1[:name])
        expect(result_podcast1.description).to be_nil
        expect(result_podcast1.feed).to eq(expected_podcast1[:feed])
        expect(result_podcast1.website).to be_nil
        expect(result_podcast2.name).to eq(expected_podcast2[:name])
        expect(result_podcast2.description).to be_nil
        expect(result_podcast2.feed).to eq(expected_podcast2[:feed])
        expect(result_podcast2.website).to be_nil
        expect(result[:metadata][:columns]).to eq(%w[name feed])
      end
    end

    context "when fields parameter is used, but the value is invalid", :populate_db do
      it "returns a failure response without data" do
        result = described_class.call({"fields" => %w[name link]})

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:invalid_column)
        expect(result[:metadata][:invalid_column]).to eq("link")
      end
    end

    context "when there are no podcasts" do
      it "returns a success response without data" do
        result = described_class.call

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:empty_table)
        expect(result[:metadata][:records]).to eq([])
      end
    end
  end
end
