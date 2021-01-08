# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Card  
        def initialize(name, comments: [], desc: '')
          @name = name
          @comments_texts = comments
          @desc = desc
        end
    
        attr_reader :name, :comments_texts, :desc
    
        def comments
          @comments_dummies ||= comments_texts.map { |c| Comment.new(c) }
        end
      end  
    end
  end
end
