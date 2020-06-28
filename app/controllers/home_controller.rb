# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @member = Trello::Member.find(:me)
    @boards = @member.boards
  end
end
