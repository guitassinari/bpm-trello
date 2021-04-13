# frozen_string_literal: true

class BoardsController < ApplicationController
  def index
    @user = Trello::Member.find(:me)
    @boards = @user.boards
  end
  
  def show
    @board = BpmTrello::Models::Board.new(Trello::Board.find(board_id))
  end

  private

  def board_id
    permitted_params[:id]
  end

  def permitted_params
    params.permit(:id)
  end
end
