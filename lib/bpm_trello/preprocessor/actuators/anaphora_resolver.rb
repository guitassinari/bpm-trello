# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Actuators
      class AnaphoraResolver
        COMMENT_SEPARATOR = ".COMMENT-SEPARATOR."

        def initialize(card)
          @card = card
        end

        def run
          preprocessed_text = Preprocess::Text.new(concatenated_comments).substitute_coreferences.to_s
          comments = preprocessed_text.split(COMMENT_SEPARATOR).reverse
          BpmTrello::Preprocessor::TrelloDummies::Card.new(card.name, comments: comments, desc: card.desc)
          card
        end

        private

        attr_reader :card

        def concatenated_comments
          card.comments.reverse.join(COMMENT_SEPARATOR)
        end
      end  
    end
  end
end
