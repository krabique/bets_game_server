# frozen_string_literal: true

class HomeController < ApplicationController
  include MoneyHelpers

  def index
    @bet = Bet.new
    @accounts = current_user.accounts
    @bets_log = current_user.bets.last(5).reverse
    @top_wins = Bet.order('win_amount_eur_cents DESC').limit(5).includes(:user)
    @exchange_rates = {
      bank_name: bank.class,
      updated_at: bank.last_updated,
      usd: bank.get_rate('EUR', 'USD')
    }
  end
end
