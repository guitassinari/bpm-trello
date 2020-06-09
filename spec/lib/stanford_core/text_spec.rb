# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StanfordCore::Text do
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

  describe '.parts_of_speech' do
    let(:expected_pos) do
      ['NNP', ',', 'VB', 'NN', 'DT', 'JJ', 'IN', 'IN', 'PRP', 'MD', 'VB', 'PRP',
       'TO', 'NNP', '.', 'JJ', '.', 'PRP', 'MD', 'VB', 'PRP', 'NN', '.', 'IN',
       'VBG', 'PRP', ',', 'VB', 'DT', 'NNS', 'VBP', '.']
    end

    it 'yeah' do
      expect(subject.parts_of_speech).to eq(expected_pos)
    end
  end
end
