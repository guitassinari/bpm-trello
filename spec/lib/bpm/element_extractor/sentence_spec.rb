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
        expect(subject.activities.first.to_s)
          .to include("Support Officer updates group calendars")
      end
    end

    context "for rule 2" do
      let(:text) { file_fixture('activities/rule_2.txt').read }
      it "works" do
        expect(subject.activities.first.to_s)
          .to include("secretary will send dispatch")
      end
    end

    context "for rule 3" do
      let(:text) { file_fixture('activities/rule_3.txt').read }
      it "works" do
        expect(subject.activities.first.to_s)
          .to include("choose document")
      end
    end

    context "for rule 4" do
      let(:text) { file_fixture('activities/rule_4.txt').read }
      it "works" do
        expect(subject.activities.first.to_s)
          .to include("client call help desk and make request")
      end
    end

    context "for rule 5" do
      let(:text) { file_fixture('activities/rule_5.txt').read }
      it "works" do
        expect(subject.activities.first.to_s)
          .to include("severity claimant evaluate")
      end
    end

    context "for rule 6" do
      let(:text) { file_fixture('activities/rule_6.txt').read }
      it "works" do
        expect(subject.activities.first.to_s)
          .to include("check and repair hardware")
      end
    end
  end

  describe ".events" do
    context "for rule 1" do
      let(:text) { file_fixture('events/rule_1.txt').read }
      it "works" do
        expect(subject.events.first.to_s)
          .to include("agent confirmed claim to clerk")
      end
    end

    context "for rule 2" do
      let(:text) { file_fixture('events/rule_2.txt').read }
      it "works" do
        expect(subject.events.first.to_s)
          .to include("file stored by back office")
      end
    end

    context "for rule 3" do
      let(:text) { file_fixture('events/rule_3.txt').read }
      it "works" do
        expect(subject.events.first.to_s)
          .to include("document received by manager")
      end
    end

    context "for rule 4" do
      let(:text) { file_fixture('events/rule_4.txt').read }
      it "works" do
        expect(subject.events.first.to_s)
          .to include("message generated to customer")
      end
    end
  end
end
