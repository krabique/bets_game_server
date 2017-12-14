# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @bet = Bet.new
    @accounts = current_user.accounts
    @bets_log = current_user.bets.last(5).reverse
  end
end
