# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Card  
        def initialize(name, comments: [], desc: '', original_card:, checklists: [])
          @name = name
          @comments_texts = comments
          @desc = desc
          @original_card = original_card
          @checklists_items_texts = checklists
        end

        attr_reader :name, :desc, :original_card

        def comments
          @comments_dummies ||= comments_texts.zip(original_card.comments).map do |comment_text, original_comment| 
            Comment.new(comment_text, original_comment: original_comment)
          end
        end

        def checklists
          @checklists ||= checklists_items_texts.zip(original_card.checklists).map do |items, original_checklist|
            TrelloDummies::Checklist.new(items, original_checklist: original_checklist)
          end
        end

        private
        
        attr_reader :comments_texts, :checklists_items_texts
        
        def method_missing(method, *args)
          return original_card.send(method, *args) if original_card.respond_to?(method)
          super
        end
      end  
    end
  end
end
