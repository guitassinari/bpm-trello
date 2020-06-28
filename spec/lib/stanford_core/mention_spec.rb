# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StanfordCore::Mention do
  let(:mention) { double(:mention) }
  let(:subject) { described_class.new(mention) }

  describe '.proper?' do
    context 'when mention is of type PROPER' do
      before do
        expect(mention)
          .to receive(:method_missing).with(:mention_type).and_return('PROPER')
      end
      it { expect(subject.proper?).to eq(true) }
    end

    context 'when mention is not of type PROPER' do
      before do
        expect(mention)
          .to receive(:method_missing).with(:mention_type).and_return('NOMINAL')
      end
      it { expect(subject.proper?).to eq(false) }
    end
  end

  describe 'nominal?' do
    context 'when mention is of type NOMINAL' do
      before do
        expect(mention)
          .to receive(:method_missing).with(:mention_type).and_return('NOMINAL')
      end
      it { expect(subject.nominal?).to eq(true) }
    end

    context 'when mention is not of type NOMINAL' do
      before do
        expect(mention)
          .to receive(:method_missing).with(:mention_type).and_return('PROPER')
      end
      it { expect(subject.nominal?).to eq(false) }
    end
  end

  describe '.to_s' do
    let(:mention_span) { 'a mention' }
    before do
      expect(mention)
        .to receive(:method_missing)
        .with(:mention_span).and_return(mention_span)
    end

    it 'returns the mentions mention_span' do
      expect(subject.to_s).to eq(mention_span)
    end
  end
end
