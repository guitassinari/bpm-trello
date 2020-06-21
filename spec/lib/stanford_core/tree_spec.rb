# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StanfordCore::Tree do
  let(:stanford_tree) { double(:tree) }
  let!(:subject) { StanfordCore::Tree.new(stanford_tree) }

  describe '.verb_phrase?' do
    context 'when tree is a verb phrase' do
      before do
        expect(stanford_tree)
          .to receive_message_chain(:label, :value).and_return('VP')
      end

      it { expect(subject.verb_phrase?).to eq(true) }
    end

    context 'when tree is a verb phrase' do
      before do
        expect(stanford_tree)
          .to receive_message_chain(:label, :value).and_return('NP')
      end

      it { expect(subject.verb_phrase?).to eq(false) }
    end
  end

  describe '.preposition_phrase?' do
    context 'when tree is a verb phrase' do
      before do
        expect(stanford_tree)
          .to receive_message_chain(:label, :value).and_return('PP')
      end

      it { expect(subject.preposition_phrase?).to eq(true) }
    end

    context 'when tree is a verb phrase' do
      before do
        expect(stanford_tree)
          .to receive_message_chain(:label, :value).and_return('VP')
      end

      it { expect(subject.preposition_phrase?).to eq(false) }
    end
  end

  describe '.proper_noun?' do
    context 'when tree is a verb phrase' do
      before do
        expect(stanford_tree)
          .to receive_message_chain(:label, :value).and_return('NNP')
      end

      it { expect(subject.proper_noun?).to eq(true) }
    end

    context 'when tree is a verb phrase' do
      before do
        expect(stanford_tree)
          .to receive_message_chain(:label, :value).and_return('VP')
      end

      it { expect(subject.proper_noun?).to eq(false) }
    end
  end

  describe '.noun_phrase?' do
    context 'when tree is a verb phrase' do
      before do
        expect(stanford_tree)
          .to receive_message_chain(:label, :value).and_return('NP')
      end

      it { expect(subject.noun_phrase?).to eq(true) }
    end

    context 'when tree is a verb phrase' do
      before do
        expect(stanford_tree)
          .to receive_message_chain(:label, :value).and_return('VP')
      end

      it { expect(subject.noun_phrase?).to eq(false) }
    end
  end

  describe '.leaf?' do
    context 'when tree is a leaf' do
      before { expect(stanford_tree).to receive(:is_leaf).and_return(true) }

      it { expect(subject.leaf?).to eq(true) }
    end

    context 'when tree is a leaf' do
      before { expect(stanford_tree).to receive(:is_leaf).and_return(false) }

      it { expect(subject.leaf?).to eq(false) }
    end
  end

  describe '.verb_phrase_with_noun?' do
    context 'when tree is a phrase' do
      before do
        expect(stanford_tree)
          .to receive_message_chain(:label, :value).and_return('VP')
      end

      context 'and its second element is a noun phrase' do
        let(:child_1) { double(:child_1) }
        let(:child_2) { double(:child_2) }
        before do
          expect(stanford_tree).to receive(:children).and_return(
            [child_1, child_2]
          )
          expect(child_2)
            .to receive_message_chain(:label, :value).and_return('NP')
        end

        it { expect(subject.verb_phrase_with_noun?).to eq(true) }
      end

      context 'and its second element is not a noun phrase' do
        let(:child_1) { double(:child_1) }
        let(:child_2) { double(:child_2) }
        before do
          expect(stanford_tree).to receive(:children).and_return(
            [child_1, child_2]
          )
          expect(child_2)
            .to receive_message_chain(:label, :value).and_return('VP')
        end

        it { expect(subject.verb_phrase_with_noun?).to eq(false) }
      end

      context 'and its second element is nil' do
        before do
          expect(stanford_tree)
            .to receive_message_chain(:children).and_return([])
        end

        it { expect(subject.verb_phrase_with_noun?).to eq(false) }
      end
    end
  end

  describe '.to_s' do
    context 'when tree is a leaf' do
      let(:tree_to_s) { 'a string' }
      before do
        expect(stanford_tree).to receive(:is_leaf).and_return(true)
        expect(stanford_tree).to receive(:to_s).and_return(tree_to_s)
      end

      it 'returns tree.to_s' do
        expect(subject.to_s).to eq(tree_to_s)
      end
    end

    context 'when tree is not a leaf' do
      let(:leaf_1) { double(:leaf_1, is_leaf: true, to_s: 'leaf 1.') }
      let(:leaf_2) { double(:leaf_2, is_leaf: true, to_s: 'leaf 2') }
      let(:leaves) { [leaf_1, leaf_2] }

      before do
        expect(stanford_tree).to receive(:is_leaf).and_return(false)
        expect(stanford_tree).to receive(:get_leaves).and_return(leaves)
      end

      context 'when a leaf is a punctuation' do
        context '.' do
          let(:leaf_2) { double(:leaf_2, is_leaf: true, to_s: '.') }

          it 'removes white space before the punctuation' do
            expect(subject.to_s).to eq(leaves.map(&:to_s).join)
          end
        end

        context ',' do
          let(:leaf_2) { double(:leaf_2, is_leaf: true, to_s: ',') }

          it 'removes white space before the punctuation' do
            expect(subject.to_s).to eq(leaves.map(&:to_s).join)
          end
        end
      end

      it 'joins texts of all of its leaves' do
        expect(subject.to_s).to eq(leaves.map(&:to_s).join(' '))
      end
    end
  end

  
end
