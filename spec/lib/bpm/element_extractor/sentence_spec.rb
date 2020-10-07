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
          .to include("agent confirm claim")
      end
    end

    context "for rule 2" do
      let(:text) { file_fixture('events/rule_2.txt').read }
      it "works" do
        expect(subject.events.first.to_s)
          .to include("file store back office")
      end
    end

    context "for rule 3" do
      let(:text) { file_fixture('events/rule_3.txt').read }
      it "works" do
        expect(subject.events.first.to_s)
          .to include("document receive manager")
      end
    end

    context "for rule 4" do
      let(:text) { file_fixture('events/rule_4.txt').read }
      it "works" do
        expect(subject.events.first.to_s)
          .to include("message generate customer")
      end
    end
  end

  describe ".exclusive_gateways" do
    context "for rule 1" do
      let(:text) { file_fixture('exclusive_gateways/rule_1.txt').read }
      it "works" do
        expect(subject.exclusive_gateways.first.to_s)
          .to include("agent confirm claim")
      end
    end

    context "for rule 2" do
      let(:text) { file_fixture('exclusive_gateways/rule_2.txt').read }
      it "works" do
        expect(subject.exclusive_gateways.first.to_s)
          .to include("file store back office")
      end
    end

    context "for rule 3" do
      let(:text) { file_fixture('exclusive_gateways/rule_3.txt').read }
      it "works" do
        expect(subject.exclusive_gateways.first.to_s)
          .to include("document receive manager")
      end
    end

    context "for rule 4" do
      let(:text) { file_fixture('exclusive_gateways/rule_4.txt').read }
      it "works" do
        expect(subject.exclusive_gateways.first.to_s)
          .to include("message generate customer")
      end
    end
  end
end
