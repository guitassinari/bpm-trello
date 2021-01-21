# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Actuators
      class MarkdownLinksNormalizer < Base
        def run
          comments = card.comments.map(&:text).map { |c| normalize_links_in(c) }
          desc = normalize_links_in(card.desc)
          build_card_dummy(card.name, comments: comments, desc: desc)
        end

        private

        def normalize_links_in(text)
          text.gsub(/\[(.*?)\]\(.*?\)/, '\1')
        end
      end  
    end
  end
end
