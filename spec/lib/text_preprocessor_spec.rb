# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextPreprocessor do
  let(:text) do
    'Alessandro, please review this pull-request so that we can get it to QA. Sure. I will review it today. Before reviewing it, let all tests pass.'
  end
  let(:subject) { described_class.new(Text.new(text)) }
  
  describe ".substitute_coreferences" do
    let(:expected_text) do
      'Alessandro, please review pull-request so that we can get pull-request to QA. Sure. Alessandro will review pull-request today. Before reviewing pull-request, let all tests pass.'
    end

    it 'works' do
      expect(subject.substitute_coreferences).to eq(expected_text)
    end
  end
end
