# frozen_string_literal: true

class CardActivitiesExtractor
  def initialize(trello_card)
    @card = trello_card
  end

  def activities
    preprocessor = TextPreprocessor.new(comments_as_conversation)
                                   .substitute_coreferences
                                   .remove_determiners
    TextActivitiesExtractor.new(preprocessor.to_s).activities
  end

  private

  def comments_as_conversation
    @comments_as_conversation ||= ([preprocessed_card_name] + comments_texts).join("\n")
  end

  def preprocessed_card_name
    @card.name + '.'
  end

  def comments_texts
    comments.map(&:text)
  end

  def comments
    @comments ||= @card.comments.reverse
  end
end
