# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @user = Trello::Member.find(:me)
    @boards = @user.boards
  end
end
