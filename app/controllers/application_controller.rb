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
