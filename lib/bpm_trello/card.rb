# frozen_string_literal: true

module BpmTrello
  class Card
    def initialize(trello_card)
      @card = trello_card
    end
  
    def activities
      Bpm::ElementExtractor::Text.new(comments_as_conversation).activities
    end
  
    def comments_as_conversation
      @comments_as_conversation ||= ([preprocessed_card_name] + comments_texts).join("\n")
    end
  
    private
  
    def preprocessed_card_name
      @card.name + '.'
    end
  
    def comments_texts
      comments.map(&:text)
    end
  
    def comments
      @comments ||= @card.comments.reverse
    end
  end  
end
