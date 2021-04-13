# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    ACTUATORS = [
      Preprocessor::Actuators::Periodifier,
      Preprocessor::Actuators::MarkdownLinksNormalizer,
      Preprocessor::Actuators::TrelloLinksNormalizer,
      Preprocessor::Actuators::MentionSubstitution,
      Preprocessor::Actuators::AnaphoraResolver,
      Preprocessor::Actuators::PronounsSubstitution,
      Preprocessor::Actuators::NoiseRemover
    ]

    def self.preprocess(card)
      preprocessed_card = ACTUATORS.reduce(card) do |card, actuator|
        actuator.new(card).run
      end
      BpmTrello::Models::Card.new(preprocessed_card)
    end
  end  
end
