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
            graph.verbs.map do |verb|
              or_verbs = graph.all_or_conjunctions_of(verb)
              and_verbs = graph.all_and_conjunctions_of(verb)
              or_activities = or_verbs.map { |v| extract_activity_from_verb(v) }
              and_activities = and_verbs.map { |v| extract_activity_from_verb(v) }
              extract_activity_from_verb(verb)
            end.select(&:present?)
          end
  
          private
  
          attr_reader :graph

          def extract_activity_from_verb(verb)
            subjects = subjects_by_verb(verb)
            objects = objects_by_verb(verb)
            lemmatized_verb = lemmatizer.lemma(verb.word, :verb)
            or_verbs = graph.all_or_conjunctions_of(verb)
            and_verbs = graph.all_and_conjunctions_of(verb)
            ors = or_verbs.map { |v| extract_activity_from_verb(v) }
            ands = and_verbs.map { |v| extract_activity_from_verb(v) }
            BpmInfoExtractor::Models::Activity.new(lemmatized_verb, subjects, objects, ors_activities: ors, ands_activities: ands)
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
            [modifiers_string, noun_indexed_word.word].select(&:present?).join(' ')
          end
  
          def lemmatizer
            @lemmatizer ||= Lemmatizer.new
          end
        end
      end
    end
  end
end
