# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Nlp
      module ActivitiesExtractor
        class Activity
          def initialize(verb, subjects, objects)
            @verb = verb
            @subjects = subjects
            @objects = objects
          end
  
          def to_s
            concatenated_subjects + ' ' + @verb + ' ' + concatenated_objects
          end
  
          private
  
          def concatenated_subjects
            @subjects.join(' and ')
          end
  
          def concatenated_objects
            @objects.join(' and ')
          end
        end
      end
    end
  end
end
