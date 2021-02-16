# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Nlp
      module ActivitiesExtractor
        class SemanticGraphActivitiesExtractor
          def initialize(graph)
            @graph = graph
          end
  
          def activities
            verbs.map do |verb|
              subjects = subjects_by_verb(verb)
              objects = objects_by_verb(verb)
              lemmatized_verb = lemmatizer.lemma(verb.word, :verb)
              Activity.new(lemmatized_verb, subjects, objects)
            end
          end
  
          private
  
          attr_reader :graph
  
          def verbs
            graph.subject_relations.map(&:governor)
          end
  
          def subjects_by_verb(verb_indexed_word)
            direct_subjects = graph.all_subjects_of(verb_indexed_word)  
            conjunction_subjects = direct_subjects.map { |s| graph.all_conjunctions_of(s) }
            all_subjects = direct_subjects + conjunction_subjects.flatten(1)
            all_subjects.map { |subject| compose_noun(subject) }
          end
  
          def objects_by_verb(verb_indexed_word)
            objects = graph.all_objects_of(verb_indexed_word)
            objects_conjunctions = objects.map { |o| graph.all_conjunctions_of(o) }
            all_objects = objects + objects_conjunctions.flatten(1)
            all_objects.map { |object| compose_noun(object) }
          end
  
          def compose_noun(noun_indexed_word)
            modifiers = graph.noun_modifiers_of(noun_indexed_word)
            modifiers_string = modifiers.map(&:word).join(' ')
            [modifiers_string, noun_indexed_word.word].join(' ')
          end
  
          def lemmatizer
            @lemmatizer ||= Lemmatizer.new
          end
        end
      end
    end
  end
end