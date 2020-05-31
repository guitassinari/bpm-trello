# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Text do
  let(:text) do
    'Alessandro, please review this pull-request so that we can get it to QA.
    Sure. I will review it today.
    Before reviewing, let all tests pass.'
  end
  let(:subject) { Text.new(text) }

  describe '.activities' do
    let(:activities) do
      ['review pull-request', 'get pull-pequest to QA']
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

  describe '.sentences' do
    let(:sentences) do
      ['Angela Merkel met Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package.',
       'Sarkozy looked pleased, but Merkel was dismayed.']
    end

    it 'returns all text sentences' do
      expect(subject.sentences).to eq(sentences)
    end
  end

  describe '.lemmas' do
    let(:lemmas) do
      ['Angela', 'Merkel', 'meet', 'Nicolas', 'Sarkozy', 'on', 'January',
       '25th', 'in', 'Berlin', 'to', 'discuss', 'a', 'new', 'austerity',
       'package', '.', 'Sarkozy', 'look', 'pleased', ',', 'but', 'Merkel', 'be',
       'dismayed', '.']
    end

    it 'returns all text sentences' do
      expect(subject.lemmas).to eq(lemmas)
    end
  end

  describe '.to_s' do
    it 'returns the original text' do
      expect(subject.to_s).to eq(text)
    end
  end
end
