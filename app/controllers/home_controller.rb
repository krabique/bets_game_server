# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @bet = Bet.new
    @accounts = current_user.accounts
    @bets_log = current_user.bets.last(5).reverse
    @top_wins = Bet.order("win_amount_eur_cents DESC").limit(5)
  end
end
