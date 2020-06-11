# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StanfordCore::Token do
  let(:text) { file_fixture('text.txt').read }
  let(:text_obj) { StanfordCore::Text.new(text) }
  let(:subject) { text_obj.tokens.first }

  describe '.determiner?' do
    context 'when its pos tag is DT' do
      before do
        expect(subject).to receive(:part_of_speech_tag).and_return('DT')
      end

      it 'returns true' do
        expect(subject.determiner?).to eq(true)
      end
    end

    context 'when its pos tag is not DT' do
      before do
        expect(subject).to receive(:part_of_speech_tag).and_return('VB')
      end

      it 'returns false' do
        expect(subject.determiner?).to eq(false)
      end
    end
  end

  describe '.part_of_speech_tag' do
    it 'returns the token pos tag' do
      expect(subject.part_of_speech_tag).to eq('NNP')
    end
  end

  describe '.lemma' do
    let(:subject) { text_obj.tokens[3] }
    it 'returns the token in its lemma form' do
      expect(subject.lemma).to eq('review')
    end
  end

  describe '.coreference?' do
    context 'when token belongs to a coreference cluster' do
      before do
        expect(subject).to receive(:coreference_cluster_id).and_return(1)
      end

      it 'returns true' do
        expect(subject.coreference?).to eq(true)
      end
    end

    context 'when token doesnt belong to a coreference cluster' do
      before do
        expect(subject)
          .to receive(:coreference_cluster_id).and_return(nil)
      end

      it 'returns false' do
        expect(subject.coreference?).to eq(false)
      end
    end
  end

  describe '.coreference_cluster_id' do
    context 'when token belongs to a coreference cluster' do
      let(:id) { 1 }
      before do
        expect(subject)
          .to receive(:coref_cluster_id_string).twice.and_return(id.to_s)
      end

      it 'returns the coreference cluster ID is int' do
        expect(subject.coreference_cluster_id).to eq(id)
      end
    end

    context 'when token doesnt belong to a coreference cluster' do
      before do
        expect(subject)
          .to receive(:coref_cluster_id_string).and_return(nil)
      end

      it 'returns false' do
        expect(subject.coreference_cluster_id).to eq(nil)
      end
    end
  end

  describe '.to_s' do
    let(:expected_value) { 'Alessandro' }

    it 'returns the token original string' do
      expect(subject.to_s).to eq(expected_value)
    end
  end
end
