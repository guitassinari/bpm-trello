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

        def build_card_dummy(card_name, comments:, desc: card.desc)
          original_card = if card.is_a?(BpmTrello::Preprocessor::TrelloDummies::Card)
                            card.original_card
                          else
                            card
                          end
          BpmTrello::Preprocessor::TrelloDummies::Card.new(card_name, comments: comments, desc: card.desc, original_card: original_card)
        end
      end  
    end
  end
end
