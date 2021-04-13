# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    def self.extract_from(card)
      card_activity = Actuators::TaskDefinition.new(card).extract
      activities = Actuators::ActivitiesExtractor.new(card).extract
      checklist_activities = Actuators::ChecklistSubtasks.new(card).extract
      Models::CardProcess.new(card_activity, checklist_activities, activities).to_s
    end
  end  
end
