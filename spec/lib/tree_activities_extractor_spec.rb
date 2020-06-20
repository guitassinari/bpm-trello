# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TreeActivitiesExtractor do
  let(:text) { file_fixture('text.txt').read }
  let(:sentence) { StanfordCore::Text.new(text).sentences_objects.first }
  let(:subject) { described_class.new(sentence.tree) }

  describe '.activities_phrases' do
    let(:expected_phrases) { ['get it to QA'] }
    it 'returns activities phrases from the sentence' do
      expect(subject.activities_phrases).to eq(expected_phrases)
    end
  end
end
