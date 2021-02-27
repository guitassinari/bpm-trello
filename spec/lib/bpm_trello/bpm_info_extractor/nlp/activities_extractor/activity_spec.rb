# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BpmTrello::BpmInfoExtractor::Nlp::ActivitiesExtractor::Activity do
  let(:verb) { 'eat' }
  let(:subjects) { ['Guilherme', 'John'] }
  let(:objects) { ['seafood'] }
  let(:ands) { [double(:and_activity, to_s: 'create a shark')] }
  let(:ors) { [double(:or_activity, to_s: 'kill a fish')] }
  let(:subject) { described_class.new(verb, subjects, objects, ors, ands) }

  describe '.to_s' do
    it 'works' do
      expect(subject.to_s).to eq(["Guilherme does homework"])
    end
  end
end
