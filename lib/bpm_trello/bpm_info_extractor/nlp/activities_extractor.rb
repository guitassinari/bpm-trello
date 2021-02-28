# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Nlp
      module ActivitiesExtractor
        def self.extract(text)
          nlp_text = StanfordCore::Text.new(text)
          sentences_with_verbs = nlp_text.sentences_objects.select(&:has_verb?)
          
          activities = sentences_with_verbs.map do |sentence_obj|
            SemanticGraphActivitiesExtractor.new(sentence_obj.semantic_graph).activities
          end.flatten(1)

          qualified_activities = activities.select(&:qualified?)

          reverse_activities = qualified_activities.reverse
          reverse_activities.each do |act|
            reverse_activities.each do |act_2|
              if act != act_2 && act_2.contains?(act)
                reverse_activities.delete(act)
              end
            end
          end

          reverse_activities.reverse
        end
      end
    end
  end
end
