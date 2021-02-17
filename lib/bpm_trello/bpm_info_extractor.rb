# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    def self.extract_from(card)
      task_defition = Actuators::TaskDefinition.new(card).extract
      activities = Actuators::ActivitiesExtractor.new(card).extract
      ([task_defition] + activities.select(&:complete?)).join('. ')
    end
  end  
end
