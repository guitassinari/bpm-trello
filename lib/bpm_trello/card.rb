# frozen_string_literal: true

module BpmTrello
  class Card < SimpleDelegator
    include BpmTrello::ElementExtractor
  
    def activities
      extract_activities
    end

    def events
      extract_events
    end
  
    def comments_as_conversation
      @comments_as_conversation ||= ([preprocessed_card_name] + comments_texts).join(" ")
    end
  
    private
  
    def preprocessed_card_name
      name + '.'
    end
  
    def comments_texts
      comments.map(&:text).map do |comment_text|
        stripped_comment = comment_text.squeeze(' ')
        if stripped_comment.last != "."
          stripped_comment + "."
        else
          stripped_comment
        end
      end
    end
  
    def comments
      @comments ||= super.reverse
    end
  end  
end
