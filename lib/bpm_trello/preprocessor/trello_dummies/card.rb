# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Card  
        def initialize(name, comments: [], desc: '', original_card:)
          @name = name
          @comments_texts = comments
          @desc = desc
          @original_card = original_card
        end
    
        attr_reader :name, :comments_texts, :desc, :original_card
    
        def comments
          @comments_dummies ||= comments_texts.zip(original_card.comments).map do |comment_text, original_comment| 
            Comment.new(comment_text, original_comment: original_comment)
          end
        end

        def method_missing(method, *args)
          return original_card.send(method, *args) if original_card.respond_to?(method)
          super
        end
      end  
    end
  end
end
