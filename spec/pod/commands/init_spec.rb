# frozen_string_literal: true

require_relative '../../support/test_helpers.rb'

RSpec.describe Pod::Commands::Init do
  describe '#call' do
    context 'when no error occurs' do
      it 'returns a success response and creates the initial pod config' do
        result = described_class.call

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:successfully_initialized)
        expect(Dir.exist?(TestHelpers::Path.config_dir)).to eq(true)
        expect(File.exist?(TestHelpers::Path.db_dir)).to eq(true)
      end
    end

    context "when ENV['HOME'] returns nil" do
      it 'returns a failure response and does not create the initial config' do
        allow(ENV).to receive(:[]).with('HOME').and_return(nil)

        result = described_class.call

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:home_not_found)
        expect(Dir.exist?(TestHelpers::Path.config_dir)).to eq(false)
        expect(File.exist?(TestHelpers::Path.db_dir)).to eq(false)
      end
    end

    context 'when FileUtils fails and raises an exception ' do
      it 'returns a failure response and does not create the initial config' do
        allow(FileUtils).to receive(:mkdir_p)
                              .and_raise(SystemCallError.new('Obscure error', 1))

        result = described_class.call

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:cannot_create_initial_config)
        expect(Dir.exist?(TestHelpers::Path.config_dir)).to eq(false)
        expect(File.exist?(TestHelpers::Path.db_dir)).to eq(false)
      end
    end

    context 'when FileUtils fails, but does not raise an exception' do
      it 'returns a failure response and does not create the initial config' do
        allow(FileUtils).to receive(:mkdir_p).and_return(nil)

        result = described_class.call

        expect(result[:status]).to eq(:failure)
        expect(result[:details]).to eq(:cannot_create_initial_config)
        expect(Dir.exist?(TestHelpers::Path.config_dir)).to eq(false)
        expect(File.exist?(TestHelpers::Path.db_dir)).to eq(false)
      end
    end

    context 'when pod already was initialized' do
      it 'returns a success response without creating the initial config' do
        described_class.call
        before_db_file_creation_date = File.new(TestHelpers::Path.db_dir).ctime

        result = described_class.call

        expect(result[:status]).to eq(:success)
        expect(result[:details]).to eq(:already_initialized)
        expect(File.new(TestHelpers::Path.db_dir).ctime).to eq(before_db_file_creation_date)
      end
    end
  end
end

