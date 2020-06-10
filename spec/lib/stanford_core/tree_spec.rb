# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StanfordCore::Tree do
  let(:text) { file_fixture('text.txt').read }
  let(:sentence) { text.split('.').first + '.' }
  let!(:subject) { StanfordCore::Text.new(text).sentences_objects.first.tree }

  describe '.verb_phrase_with_noun?' do
    context 'when tree is a phrase' do
      context 'and its second element is a noun phrase' do
        before { mock_second_child_as_noun_phrase(true) }

        it { expect(subject.verb_phrase_with_noun?).to eq(true) }
      end

      context 'and its second element is not a noun phrase' do
        before { mock_second_child_as_noun_phrase(false) }

        it { expect(subject.verb_phrase_with_noun?).to eq(false) }
      end

      context 'and its second element is nil' do
        before do
          expect(subject)
            .to receive_message_chain(:children, :[]).and_return(nil)
        end

        it { expect(subject.verb_phrase_with_noun?).to eq(false) }
      end
    end
  end

  describe '.to_s' do
    it 'works' do
      expect(subject.to_s).to eq(sentence)
    end
  end
end
