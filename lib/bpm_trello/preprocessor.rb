# frozen_string_literal: true

module BpmTrello
  module Preprocessor
    def self.preprocess(card)
      preprocessed_name = card.name
      preprocessed_comments_texts = card.comments.map(&:text).map do |comment_text|
        stripped_comment = comment_text.strip
        if stripped_comment.last != "."
          stripped_comment + "."
        else
          stripped_comment
        end
      end

      dummy = Preprocessor::TrelloDummies::Card.new(preprocessed_name, desc: card.desc, comments: preprocessed_comments_texts)
      new_dummy = Preprocessor::Actuators::AnaphoraResolver.new(dummy).run
      new_new_dummy = Preprocessor::Actuators::MarkdownLinksNormalizer.new(dummy).run
      BpmTrello::Card.new(new_new_dummy)
    end
  end  
end
