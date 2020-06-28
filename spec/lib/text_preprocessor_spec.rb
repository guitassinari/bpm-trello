# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextPreprocessor do
  let(:text) { file_fixture('text.txt').read }
  let(:preprocessed_text) { file_fixture('preprocessed_text.txt').read }
  let(:subject) { described_class.new(text) }

  describe '.substitute_coreferences' do
    let(:expected_text) do
      'Alessandro, please review this this pull-request so that we can get this pull-request to QA. Sure. I will review this pull-request today. Before reviewing this pull-request, let all tests pass.'
    end

    it 'works' do
      expect(subject.substitute_coreferences.to_s).to eq(expected_text)
    end
  end

  describe '.remove_teterminers' do
    let(:expected_text) do
      'Alessandro, please review pull-request so that we can get it to QA. Sure. I will review it today. Before reviewing it, let tests pass.'
    end

    it 'works' do
      expect(subject.remove_determiners.to_s).to eq(expected_text)
    end
  end

  describe 'fully processed text' do
    it 'works as expected' do
      expect(subject.substitute_coreferences.remove_determiners.to_s)
        .to eq(preprocessed_text)
    end
  end
end
