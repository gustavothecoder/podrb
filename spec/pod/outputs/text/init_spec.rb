# frozen_string_literal: true

RSpec.describe Pod::Outputs::Text::Init do
  describe '#generate_msg' do
    context 'when home is not found' do
      it 'returns the correct message' do
        response = described_class.new(status: :failure, details: :home_not_found)
        expected_output = <<~OUTPUT
          It seems that $HOME is empty. Is your home directory set up correctly?
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context 'when pod already was initialized' do
      it 'returns the correct message' do
        response = described_class.new(status: :success, details: :already_initialized)
        expected_output = <<~OUTPUT
          Pod already was initialized!
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context 'when pod was successfully initialized' do
      it 'returns the correct message' do
        response = described_class.new(status: :success, details: :successfully_initialized)
        expected_output = <<~OUTPUT
          Pod successfully initialized!
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end

    context 'when some error occurs when creating the config files' do
      it 'returns the correct message' do
        response = described_class.new(status: :failure, details: :cannot_create_initial_config)
        expected_output = <<~OUTPUT
          Pod couldn't create the config files.
        OUTPUT

        msg = response.call

        expect(msg).to eq(expected_output)
      end
    end
  end
end

