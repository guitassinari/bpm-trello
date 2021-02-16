# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BpmTrello::BpmInfoExtractor::Nlp::ActivitiesExtractor do
  let(:text) { "Guilherme and Nicolas always created beautiful post images and videos" }
  let(:subject) { described_class.extract(text) }

  describe '.extract' do
    it 'works' do
      expect(subject.map(&:to_s)).to eq(["Guilherme does homework"])
    end
  end
end
