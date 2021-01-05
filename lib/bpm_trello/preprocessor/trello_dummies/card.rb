# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Card  
        def initialize(name, comments: [])
          @name = name
          @comments_texts = comments
        end
    
        attr_reader :name
    
        def comments
          @comments_dummies ||= @comments_texts.map { |c| Comment.new(c) }
        end
      end  
    end
  end
end
