# frozen_string_literal: true

require "rails_helper"

RSpec.describe Text do
  let(:text) do
    'Angela Merkel met Nicolas Sarkozy on January 25th in ' +
      'Berlin to discuss a new austerity package. Sarkozy ' +
      'looked pleased, but Merkel was dismayed.'
  end
  let(:subject) { Text.new(text) }

  describe ".activities" do
    let(:activities) do
      ["met Nicolas Sarkozy", "to discuss a new austerity package"]
    end

    it "returns all activities in the text string" do

      expect(subject.activities).to eq(activities)
    end

    context "for an empty text" do
      it "returns an empty array" do
        expect(subject.activities).to eq([])
      end
    end
  end

  describe ".sentences" do
    let(:sentences) do
      ["Angela Merkel met Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package.",
       "Sarkozy looked pleased, but Merkel was dismayed."]
    end

    it "returns all text sentences" do
      expect(subject.sentences).to eq(sentences)
    end
  end

  describe ".lemmas" do
    let(:sentences) do
      ["Angela Merkel met Nicolas Sarkozy on January 25th in Berlin to discuss a new austerity package.",
       "Sarkozy looked pleased, but Merkel was dismayed."]
    end

    it "returns all text sentences" do
      expect(subject.lemmas).to eq(sentences)
    end
  end
end
