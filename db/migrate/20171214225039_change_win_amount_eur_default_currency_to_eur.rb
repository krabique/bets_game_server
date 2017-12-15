# frozen_string_literal: true

class ChangeWinAmountEurDefaultCurrencyToEur < ActiveRecord::Migration[5.1]
  def change
    change_column_default :bets, :win_amount_eur_currency, from: 'USD',
                                                           to: 'EUR'
  end
end
