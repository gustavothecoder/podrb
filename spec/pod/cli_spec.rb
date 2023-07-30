# frozen_string_literal: true

require 'spec_helper'
require 'open3'

RSpec.describe Pod::CLI do
  describe 'input interpretation' do
    context 'when input is valid' do
      it 'executes the command' do
        stdout, _, __ = Open3.capture3('pod version')

        expect(stdout.chomp).to eq(Pod::VERSION)
      end
    end

    context 'when the input is invalid' do
      it 'tells the user that the command was not found' do
        _, stderr, __ = Open3.capture3('pod invalid')

        expect(stderr.chomp).to eq('Could not find command "invalid".')
      end
    end
  end
end

