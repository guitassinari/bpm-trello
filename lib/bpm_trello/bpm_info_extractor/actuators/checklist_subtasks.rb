# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Actuators
      class ChecklistSubtasks < Base
        def extract
          card.checklists.map do |checklist|
            checklist.items.map do |item|
              Nlp::ActivitiesExtractor.extract(item.name)
            end
          end.flatten
        end

        private
      end  
    end
  end
end
