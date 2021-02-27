# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    def self.extract_from(card)
      task_defition = Actuators::TaskDefinition.new(card).extract
      activities = Actuators::ActivitiesExtractor.new(card).extract
      checklist_activities = Actuators::ChecklistSubtasks.new(card).extract
      task_definition_list = [task_defition]
      all_tasks = task_definition_list + activities + checklist_activities
      all_tasks.join('. ')
    end
  end  
end
