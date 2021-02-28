# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BpmTrello::BpmInfoExtractor::Actuators::ChecklistSubtasks do
  let(:checklists) { 
    [double(:checklist_1, items: [double(:item_1, name: "Create a huge car and deliver it to Donald Trump")])]
  }
  let(:card) { double(:card, checklists: checklists) }
  let(:subject) { described_class.new(card).extract }

  describe '.extract' do
    it 'works' do
      expect(subject).to eq("Guilherme create the campaign at ")
    end
  end
end
