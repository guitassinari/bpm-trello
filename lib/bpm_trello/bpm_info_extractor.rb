# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    def self.extract_from(card)
      card_name_activities = Nlp::ActivitiesExtractor.new(card.name).extract
      card_description_activities = Nlp::ActivitiesExtractor.new(card.desc).extract
      card_comments_activities = Nlp::ActivitiesExtractor.new(card.comments_as_conversation).extract

      [
        card_name_activities,
        card_description_activities,
        card_comments_activities
     ].flatten(1).join('. ')
    end
  end  
end
