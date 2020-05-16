# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @member = Trello::Member.find(:me)
    @boards = @member.boards.map do |board|
      organization_name = begin
        board.organization_id.present? ? Trello::Organization.find(board.organization_id)&.name : "Personal"
      rescue
        "Unauthorized"
      end
      active_message = board.closed? ? "closed" : "active"
      "#{organization_name} - #{board.name} - #{active_message}" 
    end
  end
end
