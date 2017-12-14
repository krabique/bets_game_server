# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @bet = Bet.new
    @accounts = current_user.accounts
  end
end
