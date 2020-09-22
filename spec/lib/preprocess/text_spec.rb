# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Preprocess::Text do
  let(:subject) { described_class.new(text) }

  describe '.substitute_markdown_links' do
    let(:label) { double(:label) }
    let(:link) { double(:link) }
    let(:text) { "[#{label}](#{link})" }

    it 'substitutes the whole markdown link structure by its label' do
      expect(subject.substitute_markdown_links.to_s).to eq(label.to_s)
    end

    context "with multiple links in the same sentence" do
      let(:label_2) { double(:label_2) }
      let(:link_2) { double(:link_2) }
      let(:text) { "[#{label}](#{link}), \n yeah, ok, [#{label_2}](#{link_2})" }

      it 'substitutes all markdown links structure by its label' do
        expect(subject.substitute_markdown_links.to_s)
          .to eq("#{label}, \n yeah, ok, #{label_2}")
      end
    end
  end
end
