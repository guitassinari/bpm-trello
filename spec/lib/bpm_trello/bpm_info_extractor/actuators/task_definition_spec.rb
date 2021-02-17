# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BpmTrello::BpmInfoExtractor::Actuators::TaskDefinition do
  let(:members) { 
    [double(:member_1, full_name: "Guilherme Tassinari")]
  }
  let(:card) { double(:card, name: "Create the campaign image", members: members, due_date: Time.now) }
  let(:subject) { described_class.new(card).extract }

  describe '.extract' do
    it 'works' do
      expect(subject).to eq("Guilherme create the campaign at ")
    end
  end
end
