# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Checklist < SimpleDelegator
        def initialize(items, original_checklist:)
          @items_texts = items
          @original_checklist = original_checklist
          super(@original_checklist)
        end

        def items
          @items ||= items_texts.zip(@original_checklist.items).map do |text, original_item|
            TrelloDummies::ChecklistItem.new(text, original_item: original_item)
          end
        end

        private
    
        attr_reader :items_texts
      end  
    end
  end
end
