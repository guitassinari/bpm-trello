# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Card < SimpleDelegator
        def initialize(name, comments: [], desc: '', original_card:, checklists: [])
          @name = name
          @comments_texts = comments
          @desc = desc
          @original_card = original_card
          @checklists_items_texts = checklists
          super(@original_card)
        end

        attr_reader :name, :desc, :original_card

        def comments
          @comments_dummies ||= comments_texts.zip(original_card.comments).map do |comment_text, original_comment| 
            TrelloDummies::Comment.new(comment_text, original_comment: original_comment)
          end
        end

        def checklists
          @checklists ||= checklists_items_texts.zip(original_card.checklists).map do |items, original_checklist|
            TrelloDummies::Checklist.new(items, original_checklist: original_checklist)
          end
        end

        private
        
        attr_reader :comments_texts, :checklists_items_texts
      end  
    end
  end
end
