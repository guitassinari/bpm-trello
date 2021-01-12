# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Comment  
        def initialize(text, original_comment:)
          @text = text
          @original_comment = original_comment
        end
    
        attr_reader :text
        
        def method_missing(method, *args)
          return @original_comment.send(method, *args) if @original_comment.respond_to?(method)
          super
        end
      end  
    end
  end
end
