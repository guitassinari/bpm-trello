# frozen_string_literal: true

class BoardsController < ApplicationController
  def show
    @board = Trello::Board.find(board_id)
    @cards = @board.cards(filter: :all)
    @activities = @cards.map do |card|
      sleep(0.5)
      CardActivitiesExtractor.new(card).activities
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
