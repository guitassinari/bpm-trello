# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Nlp
      module ActivitiesExtractor
        class Activity
          PRONOUNS_REGEX = /it|him|her|them|us|you/i
          def initialize(verb, subjects, objects, ors_activities=[], ands_activities=[])
            @verb = verb
            @subjects = subjects
            @objects = objects
            @ors = ors_activities
            @ands = ands_activities
          end

          def complete?
            has_subjects? && has_objects?
          end

          def present?
            has_subjects? || has_objects?
          end

          def empty?
            !present?
          end

          def has_subjects?
            @subjects.present?
          end

          def has_objects?
            @objects.present?
          end

          def qualified?
            has_objects? && !(concatenated_objects =~ PRONOUNS_REGEX)
          end
  
          def to_s
            @to_s ||= begin
              activity_string = concatenated_subjects + ' ' + @verb + ' ' + concatenated_objects + concatenated_ands + concatenated_ors
              trimmed_string = activity_string.strip
              trimmed_string[0].upcase + trimmed_string[1..-1]
            end
          end

          def contains?(activity)
            to_s.include?(activity.to_s)
          end
  
          private

          def concatenated_ands
            if @ands.present?
              ' and ' + @ands.join(' and ')
            else 
              ''
            end
          end

          def concatenated_ors
            if @ors.present?
              ' or ' + @ors.join(' or ')
            else 
              ''
            end
          end
  
          def concatenated_subjects
            @concatenated_subjects ||= @subjects.join(' and ')
          end
  
          def concatenated_objects
            @concatenated_objects ||= @objects.join(' and ')
          end
        end
      end
    end
  end
end
