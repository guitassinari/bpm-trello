# frozen_string_literal: true

module BpmTrello
  module Models
    class Card < SimpleDelegator
      include BpmTrello::ElementExtractor
    
      def activities
        extract_activities(comments_as_conversation)
      end
    
      def comments_as_conversation
        @comments_as_conversation ||= comments.reverse.map(&:text).join(" ")
      end
    end  
  end
end
