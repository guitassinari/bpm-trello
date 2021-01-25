# frozen_string_literal: true

class CardsController < ApplicationController
  def show
    trello_card = Trello::Card.find(card_id)
    @card = BpmTrello::Card.new(trello_card)

    @preprocessed_card = BpmTrello::Preprocessor.preprocess(trello_card)
  end

  private

  def card_id
    permitted_params[:id]
  end

  def permitted_params
    params.permit(:id)
  end
end
