# frozen_string_literal: true

class BoardsController < ApplicationController
  def show
    @board = BpmTrello::Board.new(Trello::Board.find(board_id))
  end

  private

  def board_id
    permitted_params[:id]
  end

  def permitted_params
    params.permit(:id)
  end
end
