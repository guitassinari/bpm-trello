# frozen_string_literal: true

module BpmTrello
  module Models
    class Board < SimpleDelegator
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
