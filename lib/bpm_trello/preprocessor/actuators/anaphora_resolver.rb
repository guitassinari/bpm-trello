# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Actuators
      class AnaphoraResolver < Base
        COMMENT_SEPARATOR = ".COMMENT-SEPARATOR."

        def run
          preprocessed_text = Preprocessor::Nlp::Utils.new(concatenated_comments).substitute_coreferences.to_s
          comments = preprocessed_text.split(COMMENT_SEPARATOR).reverse
          build_card_dummy(card.name, comments: comments, desc: card.desc)
        end

        private

        def concatenated_comments
          card.comments.map(&:text).reverse.join(COMMENT_SEPARATOR)
        end
      end  
    end
  end
end
