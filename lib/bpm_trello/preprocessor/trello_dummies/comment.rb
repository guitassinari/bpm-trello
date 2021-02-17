# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Comment < SimpleDelegator
        def initialize(text, original_comment:)
          @text = text
          @original_comment = original_comment
          super(@original_comment)
        end
    
        attr_reader :text
      end  
    end
  end
end
