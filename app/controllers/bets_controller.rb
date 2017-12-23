# frozen_string_literal: true

class BetsController < ApplicationController
  # find me in lib/
  include MoneyHelper

  def create
    @bet_processor = BetProcessor.new(current_user)
    @bet = @bet_processor.calculate_and_validate(Bet.new(bet_initial_params))
    save_bet if @bet
    info_flash(@bet_processor.info)

    @accounts = current_user.accounts
    @top_wins = Bet.order('win_amount_eur_cents DESC').limit(5).includes(:user)
    @exchange_rates = exchange_rates
  end

  private

  def save_bet
    Bet.transaction do
      commit_bet
    end
  rescue ActiveRecord::RecordInvalid
    @bet_processor.info = ['alert', "There's been an error. Woops..."]
  end

  def commit_bet
    @bet.save!
    @bet.account.update!(amount: @bet.account.amount - @bet.bet_amount +
      @bet.win_amount)
    @bet_processor.info = "You've made a bet of #{@bet.bet_amount_currency} " \
      "#{@bet.bet_amount} and won " \
      "#{@bet.bet_amount_currency} #{@bet.win_amount}!"
  end

  def info_flash(info)
    if info.is_a?(Array) && info[0] == 'alert'
      flash.now[:alert] = info[1]
    else
      flash.now[:notice] = info
    end
  end

  def bet_initial_params
    params.require(:bet).permit(:bet_amount, :bet_amount_currency)
  end
end
