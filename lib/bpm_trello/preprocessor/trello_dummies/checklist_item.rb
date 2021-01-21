# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class ChecklistItem
        def initialize(text, original_item:)
          @text = text
          @original_item = original_item
        end

        def name
          text
        end

        private
    
        attr_reader :text
        
        def method_missing(method, *args)
          return @original_item.send(method, *args) if @original_item.respond_to?(method)
          super
        end
      end  
    end
  end
end
