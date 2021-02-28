# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Models
      class Activity
        PRONOUNS_REGEX = /it|him|her|them|us|you/i
        def initialize(verb, subjects, objects, ors_activities: [], ands_activities: [], extra_info: '')
          @verb = verb.downcase
          @subjects = subjects
          @objects = objects
          @ors = ors_activities
          @ands = ands_activities
          @extra_info = extra_info
        end

        attr_reader :verb, :objects, :subjects, :ors_activities, :ands_activities, :extra_info

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
            activity_string = concatenated_subjects + ' ' + task
            activity_string.strip
          end
        end

        def task
          @task ||= (verb + ' ' + concatenated_objects + ' ' + extra_info + concatenated_ands + concatenated_ors).strip
        end

        def contains?(activity)
          to_s.include?(activity.to_s)
        end

        private

        def concatenated_ands
          if @ands.present?
            ' and ' + @ands.map(&:task).join(' and ')
          else 
            ''
          end
        end

        def concatenated_ors
          if @ors.present?
            ' or ' + @ors.map(&:task).join(' or ')
          else 
            ''
          end
        end

        def concatenated_subjects
          @concatenated_subjects ||= begin
            if has_subjects?
              @subjects.join(' and ')
            else
              'someone'
            end
          end
        end

        def concatenated_objects
          @concatenated_objects ||= @objects.join(' and ')
        end
      end
    end
  end
end
