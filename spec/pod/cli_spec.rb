# frozen_string_literal: true

require_relative '../support/helpers/cli.rb'

RSpec.describe Pod::CLI do
  describe 'input interpretation' do
    context 'when input is valid' do
      it 'executes the command' do
        stdout, _, __ = Helpers::CLI.run_cmd('pod version')

        expect(stdout.chomp).to eq(Pod::VERSION)
      end
    end

    context 'when the input is invalid' do
      it 'tells the user that the command was not found' do
        _, stderr, __ = Helpers::CLI.run_cmd('pod invalid')

        expect(stderr.chomp).to eq('Could not find command "invalid".')
      end
    end
  end
end

