# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StanfordCore::CorefMentionSet do
  let(:mention_set) { double(:mention_set) }
  let(:subject) { described_class.new(mention_set) }

  describe '.representative_mention' do
    let(:representative_mention) { double(:representative_mention) }
    let(:rep_mention_wrapper) { double(:rep_mention_wrapper) }
    before do
      expect(mention_set)
        .to receive(:method_missing).with(:get_representative_mention)
                                    .and_return(representative_mention)
      expect(StanfordCore::Mention)
        .to receive(:new).with(representative_mention)
                         .and_return(rep_mention_wrapper)
    end

    it 'returns a StanfordCore::Mention of the most representative mention' do
      expect(subject.representative_mention).to eq(rep_mention_wrapper)
    end
  end

  describe '.mention_list' do
    let(:nlp_mentions) { [double(:nlp_mention_1), double(:nlp_mention_2)] }
    let(:mention_1) { double(:mention_1) }
    let(:mention_2) { double(:mention_2) }
    before do
      expect(mention_set)
        .to receive(:method_missing).with(:get_mentions_in_textual_order)
                                    .and_return(nlp_mentions)
      expect(StanfordCore::Mention)
        .to receive(:new).with(nlp_mentions[0]).and_return(mention_1)
      expect(StanfordCore::Mention)
        .to receive(:new).with(nlp_mentions[1]).and_return(mention_2)
    end

    it 'returns a list of textual ordered mentions' do
      expect(subject.mention_list).to eq([mention_1, mention_2])
    end
  end
end
