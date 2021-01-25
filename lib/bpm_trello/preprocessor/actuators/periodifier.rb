# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Actuators
      class Periodifier < Base
        SENTENCE_ENDERS = [".", ",", "!", "?", ";"]

        def run
          preprocessed_name = periodify(card.name)
          preprocessed_comments_texts = card.comments.map(&:text).map { |c| periodify(c) }
          preprocessed_description = periodify(card.desc)
          build_card_dummy(preprocessed_name, comments: preprocessed_comments_texts, desc: preprocessed_description)
        end

        private

        def periodify(text)
          stripped_text = text.strip
          unless stripped_text.blank? || SENTENCE_ENDERS.include?(stripped_text.last)
            stripped_text + "."
          else
            stripped_text
          end
        end
      end  
    end
  end
end
