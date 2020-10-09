# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StanfordCore::Sentence do
  let(:text) { file_fixture('text.txt').read }
  let(:text_obj) { StanfordCore::Text.new(text) }
  let(:subject) { text_obj.sentences_objects.first }

  describe '.original_text' do
    let(:expected_string) { text.split('.').first + '.' }

    it 'returns the original sentence string' do
      expect(subject.original_text).to eq(expected_string)
    end
  end

  describe '.dependencies' do
    let(:expected_string) { file_fixture('sentence_dependencies.txt').read }

    it 'returns' do
      expect(subject.dependencies).to eq(expected_string)
    end
  end

  describe '.parts_of_speech' do
    let(:expected_pos_tags) do
      ["NNP", ",", "MD", "PRP", "VB", "NN", "DT", "JJ", "IN", "IN", "PRP", "MD", "VB", "PRP", "TO", "NNP", "."]
    end

    it 'returns a list of pos tags' do
      expect(subject.parts_of_speech).to eq(expected_pos_tags)
    end

    it 'equals parser parts of speech (without punctuations)' do
      expect(subject.parts_of_speech - [",", "."])
        .to eq(subject.parser_parts_of_speech)
    end
  end

  describe '.tokens' do
    it 'returns a list of all sentence tokens' do
      expect(subject.tokens.length).to eq(15)
      expect(subject.tokens.all? do |t|
        t.instance_of?(StanfordCore::Token)
      end).to eq(true)
    end
  end

  describe '.tree' do
    it 'returns an instance of StanfordCord::Tree' do
      expect(subject.tree.instance_of?(StanfordCore::Tree)).to eq(true)
    end
  end
end
