# frozen_string_literal: true

class BoardsController < ApplicationController
  def show
    @board = Trello::Board.find(board_id)
    @cards = @board.cards(filter: :all)
    @activities = @cards.map do |card|
      sleep(0.5)
      bpm_card = BpmTrello::Card.new(card)
      activities = Bpm::ElementExtractor::Text
                    .new(bpm_card.comments_as_conversation)
                    .activities
      activities.map { |a| Preprocess::Text.new(a).remove_stopwords.to_s }
    end
  end

  private

  def board_id
    permitted_params[:id]
  end

  def permitted_params
    params.permit(:id)
  end
end
