# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    def self.preprocess(card)
      preprocessed_name = card.name
      preprocessed_comments_texts = card.comments.reverse.map(&:text).map do |comment_text|
        stripped_comment = comment_text.strip
        if stripped_comment.last != "."
          stripped_comment + "."
        else
          stripped_comment
        end
      end

      dummy = Preprocessor::TrelloDummies::Card.new(preprocessed_name, comments: preprocessed_comments_texts)
      BpmTrello::Card.new(dummy)
    end
  end  
end
