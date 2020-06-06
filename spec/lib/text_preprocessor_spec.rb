# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextPreprocessor do
  let(:text) do
    file_fixture('text.txt').read
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

  describe ".remove_teterminers" do
    let(:expected_text) do
      'Alessandro, please review pull-request so that we can get it to QA. Sure. Alessandro will review it today. Before reviewing it, let tests pass.'
    end

    it 'works' do
      expect(subject.remove_determiners).to eq(expected_text)
    end
  end
end
