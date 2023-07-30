# frozen_string_literal: true

require_relative '../support/helpers/cli.rb'

RSpec.describe Pod::CLI do
  describe 'input interpretation' do
    context 'when input is valid' do
      it 'executes the command' do
        result = Helpers::CLI.run_cmd('pod version')

        expect(result).to eq(Pod::VERSION)
      end
    end

    context 'when the input is invalid' do
      it 'tells the user that the command was not found' do
        result = Helpers::CLI.run_cmd('pod invalid')

        expect(result).to eq('Could not find command "invalid".')
      end
    end
  end

  describe 'version command' do
    context 'when an alias is used' do
      it 'returns the pod version' do
        original_result = Helpers::CLI.run_cmd('pod version')

        alias_result1 = Helpers::CLI.run_cmd('pod -V')
        alias_result2 = Helpers::CLI.run_cmd('pod --version')

        expect(alias_result1).to eq(original_result)
        expect(alias_result2).to eq(original_result)
      end
    end
  end
end

