# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tree do
  let(:tree) { double(:tree) }
  let!(:subject) { described_class.new(tree) }

  describe '.verb_phrase_with_noun?' do
    let(:second_child) { double(:second_child) }
    let(:second_child_tree) { double(:second_child_tree) }

    context 'when tree is a phrase' do
      before do
        expect(tree)
          .to receive_message_chain(:label, :value)
          .and_return(Tree::VERB_PHRASE)
      end

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
          expect(tree)
            .to receive_message_chain(:children, :[]).and_return(nil)
        end

        it { expect(subject.verb_phrase_with_noun?).to eq(false) }
      end
    end
  end

  describe '.dependencies' do
    
  end

  def mock_second_child_as_noun_phrase(noun_phrase)
    expect(tree)
      .to receive_message_chain(:children, :[]).and_return(second_child)
    expect(Tree)
      .to receive(:new).with(second_child).and_return(second_child_tree)
    expect(second_child_tree)
      .to receive(:noun_phrase?).and_return(noun_phrase)
  end
end
