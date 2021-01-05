# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    module TrelloDummies
      class Comment  
        def initialize(text)
          @text = text
        end
    
        attr_reader :text
      end  
    end
  end
end
