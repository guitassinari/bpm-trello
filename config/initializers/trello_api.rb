# frozen_string_literal: true

require 'trello'

Trello.configure do |config|
  config.developer_public_key = Rails.application.credentials[:trello][:api_key] # The "key" from step 1
  config.member_token = Rails.application.credentials.[:trello][:member_token] # The token from step 2.
end