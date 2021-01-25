# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Actuators
      class TrelloLinksNormalizer < Base
        TRELLO_LINK_REGEX = /https:\/\/trello.com\/c\/(.+)\/[A-z0-9\-\.\~\:\/\?\#\[\]\@\!\$\&\'\(\)\*\+\,\;\=\%]+/

        def run
          comments = card.comments.map(&:text).map { |c| normalize_links_in(c) }
          desc = normalize_links_in(card.desc)
          checklists = card.checklists.map { |c| normalize_checklist(c) }
          build_card_dummy(card.name, comments: comments, desc: desc, checklists: checklists)
        end

        private

        def normalize_checklist(checklist)
          checklist.items.map(&:name).map do |item_text|
            normalize_links_in(item_text)
          end
        end

        def normalize_links_in(text)
          text.gsub(TRELLO_LINK_REGEX) do |link|
            card_id = link.match(TRELLO_LINK_REGEX).captures.first
            card = Trello::Card.find(card_id)
            card.name
          end
        end
      end  
    end
  end
end
