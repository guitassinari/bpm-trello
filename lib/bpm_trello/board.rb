# frozen_string_literal: true

module BpmTrello
  class Board < SimpleDelegator
    include BpmTrello::ElementExtractor
  
    def activities
      @activities ||= all_cards.map { |c| c.activities }.flatten(1)
    end

    def cards
      super(filter: :all).map { |c| BpmTrello::Card.new(c) }
    end
  
    private
    
    def all_cards
      cards(filter: :all).map { |c| BpmTrello::Card.new(c) }
    end
  end  
end
