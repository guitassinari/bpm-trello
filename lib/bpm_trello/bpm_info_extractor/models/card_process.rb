# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Models
      class CardProcess
        def initialize(card_activity, checklist_activities, other_activities)
          @card_activity = card_activity
          @checklist_activities = checklist_activities
          @other_activities = other_activities
        end

        attr_reader :card_activity, :checklist_activities, :other_activities

        def to_s
          [card_activity_string, checklist_string, other_activities_string].join('. ')
        end

        def card_activity_string
          card_activity.to_s
        end

        def checklist_string
          if checklist_activities.present?
            'In order to ' + card_activity.task  + ', ' + task_subjects_string + ' must ' +  concatenate_commans_finish_with_and(checklist_activities.map(&:task))
          else
            ''
          end
        end

        def other_activities_string
          if other_activities.present?
            'Other activities include ' + concatenate_commans_finish_with_and(other_activities)
          else
            ''
          end
        end

        def task_subjects_string
          if card_activity.has_subjects?
            concatenate_commans_finish_with_and(card_activity.subjects)
          else
            'someone'
          end
        end

        def concatenate_commans_finish_with_and(terms)
          if terms.length <= 1
            terms.first.to_s
          else
            comma_string = terms[0..-2].join(', ')
            [comma_string, terms.last].compact.join(' and ')
          end
        end
      end  
    end
  end
end