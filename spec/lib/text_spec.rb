# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Text do
  let(:text) { file_fixture('text.txt').read }
  let(:subject) { Text.new(text).preprocessed }

  describe '.activities' do
    let(:activities) do
      ['review pull-request', 'get pull-request to QA']
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
      text.split('.').map { |s| s.strip + '.' }
    end

    it 'returns all text sentences' do
      expect(subject.sentences).to eq(sentences)
    end
  end

  describe '.lemmas' do
    let(:lemmas) do
      ['Alessandro', ',', 'please', 'review', 'this', 'pull-request', 'so',
       'that', 'we', 'can', 'get', 'it', 'to', 'QA', '.', 'sure', '.', 'I',
       'will', 'review', 'it', 'today', '.', 'before', 'review', 'it', ',',
       'let', 'all', 'test', 'pass', '.']
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
