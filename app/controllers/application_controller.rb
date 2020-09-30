# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :verify_trello_api_secrets

  private

  def verify_trello_api_secrets
    redirect_to trello_settings_path unless has_all_trello_secrets?
    configure_trello
  end

  def configure_trello
    Trello.configure do |config|
      config.developer_public_key = session[:app_key]
      config.member_token = session[:api_key]
    end
  end

  def has_all_trello_secrets?
    session[:app_key].present? && session[:api_key].present?
  end
end

# Trello.configure do |config|
#   config.developer_public_key = "dbc35010b437c9852771d28949dcb876"
#   config.member_token = "f83d0eacf594c76aa301cec299a89fd05b7f949aa10a295ef80b24c7adc9ed0a"
# end
# board = BpmTrello::Board.new(Trello::Board.find("5f21d2de06d4b72527efb2f2"))