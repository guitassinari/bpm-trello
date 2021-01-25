# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Actuators
      class NoiseRemover < Base
        def run
          comments = card.comments.map(&:text).map { |c| remove_noise_sentences(c) }
          desc = remove_noise_sentences(card.desc)
          build_card_dummy(card.name, comments: comments, desc: desc)
        end

        private

        def remove_noise_sentences(text)
          StanfordCore::Text.new(text).sentences_objects.select do |sentence_object|
            sentence_object.has_verb? && !sentence_object.question?
          end.join(' ')
        end
      end  
    end
  end
end
