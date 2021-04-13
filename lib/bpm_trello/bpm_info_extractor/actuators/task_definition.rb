# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Actuators
      class TaskDefinition < Base
        def extract
          return nil unless activity.present?
          
          BpmInfoExtractor::Models::Activity.new(
            activity.verb,  
            members_names + activity.subjects,
            activity.objects,
            ors_activities: activity.ors_activities,
            ands_activities: activity.ands_activities,
            extra_info: ''
          )
        end

        private

        def members_names
          card.members.map(&:full_name)
        end

        def activity
          Nlp::ActivitiesExtractor.extract(card.name).first
        end
      end  
    end
  end
end
