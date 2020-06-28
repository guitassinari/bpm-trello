# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  get '/boards/:id', to: 'boards#show', as: 'board'
end
