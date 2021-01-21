# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Checklist  
        def initialize(items, original_checklist:)
          @items_texts = items
          @original_checklist = original_checklist
        end

        def items
          @items ||= items_texts.zip(@original_checklist.items).map do |text, original_item|
            TrelloDummies::ChecklistItem.new(text, original_item: original_item)
          end
        end

        private
    
        attr_reader :items_texts
        
        def method_missing(method, *args)
          return @original_checklist.send(method, *args) if @original_checklist.respond_to?(method)
          super
        end
      end  
    end
  end
end
