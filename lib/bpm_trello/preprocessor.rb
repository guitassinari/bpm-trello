# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    ACTUATORS = [
      Preprocessor::Actuators::Periodifier,
      Preprocessor::Actuators::MarkdownLinksNormalizer,
      Preprocessor::Actuators::TrelloLinksNormalizer,
      Preprocessor::Actuators::UsernamesResolver,
      Preprocessor::Actuators::AnaphoraResolver,
      Preprocessor::Actuators::TrelloAnaphorasResolver
    ]

    def self.preprocess(card)
      preprocessed_card = ACTUATORS.reduce(card) do |card, actuator|
        actuator.new(card).run
      end
      BpmTrello::Card.new(preprocessed_card)
    end
  end  
end
