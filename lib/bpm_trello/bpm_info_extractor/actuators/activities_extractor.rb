# frozen_string_literal: true

module BpmTrello
  module BpmInfoExtractor
    module Actuators
      class ActivitiesExtractor < Base
        def extract
          description_activities = Nlp::ActivitiesExtractor.extract(card.desc)
          comments_activities = Nlp::ActivitiesExtractor.extract(card.comments_as_conversation)
          [
            card_description_activities,
            card_comments_activities
          ].flatten(1)
        end
      end  
    end
  end
end
