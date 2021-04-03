# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module Models
      class ChecklistItem < SimpleDelegator
        def initialize(text, original_item:)
          @text = text
          @original_item = original_item
          super(@original_item)
        end

        def name
          text
        end

        private
    
        attr_reader :text
      end  
    end
  end
end
