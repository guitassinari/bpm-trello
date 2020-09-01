# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bpm::ElementExtractor::Sentence do
  let(:text) { "" }
  let(:sentence) { StanfordCore::Text.new(text).sentences_objects.first }
  let(:subject) { described_class.new(sentence) }

  describe ".activities" do
    context "for rule 1" do
      let(:text) { file_fixture('activities/rule_1.txt').read }
      it "works" do
        expect(subject.activities).not_to eq([])
      end
    end

    context "for rule 2" do
      let(:text) { file_fixture('activities/rule_2.txt').read }
      it "works" do
        expect(subject.activities).not_to eq([])
      end
    end
  end
end
