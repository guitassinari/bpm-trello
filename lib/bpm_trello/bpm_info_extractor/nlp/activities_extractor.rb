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
            graph_facade = GraphFacade.new(sentence_obj.semantic_graph)
            graph_facade.verbs.map do |verb_indexed_word|
              verb_subjects = graph_facade.subjects_by_verb(verb_indexed_word)
              verb_objects = graph_facade.objects_by_verb(verb_indexed_word)
              subjects_string = verb_subjects.map(&:word).join(' and ')
              objects_string = verb_objects.map(&:word).join(' and ')
              subjects_string + ' ' + verb_indexed_word.word + ' ' + objects_string
            end
          end
        end

        private

        def nlp_text
          @nlp_text ||= StanfordCore::Text.new(@text)
        end
      end  

      class GraphFacade
        def initialize(graph)
          @graph = graph
        end

        def verbs
          graph.subject_relations.map(&:governor)
        end

        def subjects_by_verb(verb_indexed_word)
          direct_subjects = graph.all_subjects_of(verb_indexed_word)  
          conjunction_subjects = direct_subjects.map { |s| graph.all_conjunctions_of(s) }
          direct_subjects + conjunction_subjects.flatten(1)
        end

        def objects_by_verb(verb_indexed_word)
          objects = graph.all_objects_of(verb_indexed_word)
          objects_conjunctions = objects.map { |o| graph.all_conjunctions_of(o) }
          objects + objects_conjunctions.flatten(1)
        end
        
        private

        attr_reader :graph
      end
    end
  end
end
