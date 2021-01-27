# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Nlp
      class ActivitiesExtractor
        def initialize(text)
          @text = text
        end

        def extract
          nlp_text.sentences_objects.select(&:has_verb?).map do |sentence_obj|
            
          end
        end

        private

        def nlp_text
          @nlp_text ||= StanfordCore::Text.new(text)
        end
      end  
    end
  end
end
