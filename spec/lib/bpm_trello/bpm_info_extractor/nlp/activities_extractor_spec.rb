# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BpmTrello::BpmInfoExtractor::Nlp::ActivitiesExtractor do
  let(:text) { "Guilherme always create the post images correctly" }
  let(:subject) { described_class.new(text) }

  describe '.extract' do
    it 'works' do
      expect(subject.extract).to eq(["Guilherme does homework"])
    end
  end
end
