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
          text_without_markdown = remove_markdown(text)
          Preprocessor::Nlp::NoiseSentencesRemover.new(text_without_markdown).remove
        end

        def remove_markdown(text)
          Preprocessor::Nlp::Utils.new(text).remove_markdown.to_s
        end
      end  
    end
  end
end
