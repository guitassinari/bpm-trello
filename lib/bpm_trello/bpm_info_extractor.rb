# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    def self.extract_from(card)
      activities = Actuators::ActivitiesExtractor.new(card).extract
    end
  end  
end
