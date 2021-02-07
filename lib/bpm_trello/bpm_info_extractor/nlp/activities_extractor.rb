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
            graph = sentence_obj.semantic_graph
            subject_relations = graph.subject_relations
            subject_relations.map do |relation|
              verb = relation.governor
              verb_subjects = graph.all_subjects_of(verb)
              verb_objects = graph.all_objects_of(verb)
              subjects_string = verb_subjects.map(&:word).join(' and ')
              objects_string = verb_objects.map(&:word).join(' and ')
              subjects_string + ' ' + verb.word + ' ' + objects_string
            end
          end
        end

        private

        def nlp_text
          @nlp_text ||= StanfordCore::Text.new(@text)
        end
      end  
    end
  end
end
