class TrelloSettingsController < ApplicationController
  skip_before_action :verify_trello_api_secrets
  def index; end

  def update
    session[:app_key] = trello_params[:app_key]
    session[:api_key] = trello_params[:api_key]

    configure_trello

    redirect_to root_path
  end

  private

  def trello_params
    params.permit(:app_key, :api_key)
  end
end
