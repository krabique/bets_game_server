# frozen_string_literal: true

module MaximumBet
  include MoneyHelpers

  private

  def maximum_bet_eur
    last_days_lost_bets = Bet.where(multiplier: 0, created_at:
      (Time.now - 24.hours)..Time.now)
    last_days_won_bets = Bet.where(multiplier: 2, created_at:
      (Time.now - 24.hours)..Time.now)

    income = calculate_income(last_days_lost_bets)
    outlays = calculate_outlays(last_days_won_bets)

    profit = income - outlays
    min_bet = Money.new(100, 'EUR')
    @max_bet = profit <= 0 ? min_bet : (profit / 2) + min_bet
  end

  def calculate_income(last_days_lost_bets)
    income = Money.new(0, 'EUR')
    last_days_lost_bets.each do |bet|
      income += bank.exchange(bet.bet_amount, bet.bet_amount_currency, 'EUR')
    end
    income
  end

  def calculate_outlays(last_days_won_bets)
    outlays = Money.new(0, 'EUR')
    last_days_won_bets.each do |bet|
      outlays += bank.exchange(bet.bet_amount, bet.bet_amount_currency, 'EUR')
    end
    outlays
  end
end
