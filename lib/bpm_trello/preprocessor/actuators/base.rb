# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Actuators
      class Base
        def initialize(card)
          @card = card
        end

        attr_reader :card

        private

        def build_card_dummy(card_name, comments: card.comments.map(&:name), desc: card.desc, checklists: card.checklists.map(&:items).map { |items_texts| items_texts.map(&:name) })
          original_card = if card.is_a?(BpmTrello::Preprocessor::TrelloDummies::Card)
                            card.original_card
                          else
                            card
                          end
          BpmTrello::Preprocessor::TrelloDummies::Card.new(card_name, comments: comments, desc: desc, original_card: original_card, checklists: checklists)
        end
      end  
    end
  end
end
