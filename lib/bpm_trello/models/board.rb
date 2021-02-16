# frozen_string_literal: true

module BpmTrello
  module Models
    class Board < SimpleDelegator    
      def activities
        @activities ||= all_cards.map { |c| c.activities }.flatten(1)
      end
  
      def cards
        super(filter: :all).map { |c| BpmTrello::Models::Card.new(c) }
      end
    
      private
      
      def all_cards
        cards(filter: :all).map { |c| BpmTrello::Models::Card.new(c) }
      end
    end  
  end
end
