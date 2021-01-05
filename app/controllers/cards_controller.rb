# frozen_string_literal: true

class CardsController < ApplicationController
  def show
    @card = BpmTrello::Card.new(Trello::Card.find(card_id))
  end

  private

  def card_id
    permitted_params[:id]
  end

  def permitted_params
    params.permit(:id)
  end
end
