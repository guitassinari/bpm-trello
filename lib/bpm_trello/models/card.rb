# frozen_string_literal: true

module BpmTrello
  module Models
    class Card < SimpleDelegator       
      def comments_as_conversation
        @comments_as_conversation ||= comments.reverse.map(&:text).join(" ")
      end
    end  
  end
end
