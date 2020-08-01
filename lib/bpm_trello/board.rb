# frozen_string_literal: true
require 'benchmark'

module BpmTrello
  class Board < SimpleDelegator
    include BpmTrello::ElementExtractor
  
    def activities
      all_cards.map { |c| c.activities }.flatten(1)
    end
  
    private
  
    def cards_text
      all_cards.map(&:comments_as_conversation).join('. ')
    end
    
    def all_cards
      cards(filter: :all).map { |c| BpmTrello::Card.new(c) }
    end
  end  
end
