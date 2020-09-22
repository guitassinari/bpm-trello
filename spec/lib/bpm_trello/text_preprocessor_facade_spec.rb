# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BpmTrello::TextPreprocessorFacade do
  let(:text) { file_fixture('trello/card_comments_text.txt').read }
  let(:subject) { described_class.new(text) }

  describe '.preprocess' do
    it 'works' do
      expect(subject.preprocess).to eq("")
    end
  end
end
