# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextActivitiesExtractor do
  let(:text) { file_fixture('text.txt').read }
  let(:subject) { described_class.new(text) }

  describe '.activities' do
    let(:activities) do
      ['review it', 'get it to QA']
    end

    it 'returns all activities in the text string' do
      expect(subject.activities).to match_array(activities)
    end

    context 'for an empty text' do
      let(:text) { nil }
      it 'returns an empty array' do
        expect(subject.activities).to eq([])
      end
    end
  end
end
