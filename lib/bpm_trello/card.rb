# frozen_string_literal: true

module BpmTrello
  class Card < SimpleDelegator
    include BpmTrello::ElementExtractor
  
    def activities
      extract_activities(comments_as_conversation)
    end
  
    def comments_as_conversation
      @comments_as_conversation ||= ([preprocessed_card_name] + comments_texts).join("\n")
    end
  
    private
  
    def preprocessed_card_name
      name + '.'
    end
  
    def comments_texts
      comments.map(&:text)
    end
  
    def comments
      @comments ||= super.reverse
    end
  end  
end
