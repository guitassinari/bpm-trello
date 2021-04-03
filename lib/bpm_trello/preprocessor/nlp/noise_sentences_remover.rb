# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Nlp
      class NoiseSentencesRemover
        def initialize(text)
          @text = text
        end

        def remove
          StanfordCore::Text.new(@text).sentences_objects.select do |sentence_object|
            sentence_object.has_verb? && !sentence_object.question?
          end.join(' ')
        end
      end  
    end
  end
end