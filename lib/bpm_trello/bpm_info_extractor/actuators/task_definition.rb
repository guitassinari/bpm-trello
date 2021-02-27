# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Actuators
      class TaskDefinition < Base
        def extract
          task_definition = [members_names, task_name].join(' ')
          if card.due.present?
            task_definition += ' until ' + due_date_string
          end
          task_definition
        end

        private

        def members_names
          card.members.map(&:full_name).join(" and ")
        end

        def due_date_string
          card.due.strftime("%d/%m %H:%M")
        end

        def task_name
          Nlp::ActivitiesExtractor.extract(card.name).first.to_s
        end
      end  
    end
  end
end
