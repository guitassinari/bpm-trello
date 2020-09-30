# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  get '/boards/:id', to: 'boards#show', as: 'board'
  get '/trello', to: 'trello_settings#index', as: 'trello_settings'
  post '/trello', to: 'trello_settings#update', as: 'update_trello_settings'
end
