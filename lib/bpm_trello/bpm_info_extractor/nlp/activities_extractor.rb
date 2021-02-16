# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Nlp
      module ActivitiesExtractor
        def self.extract(text)
          nlp_text = StanfordCore::Text.new(text)
          sentences_with_verbs = nlp_text.sentences_objects.select(&:has_verb?)
          
          sentences_with_verbs.map do |sentence_obj|
            SemanticGraphActivitiesExtractor.new(sentence_obj.semantic_graph).activities
          end.flatten(1)
        end
      end
    end
  end
end
