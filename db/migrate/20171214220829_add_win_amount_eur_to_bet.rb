# frozen_string_literal: true

class AddWinAmountEurToBet < ActiveRecord::Migration[5.1]
  def change
    add_monetize :bets, :win_amount_eur, amount: { null: false, default: 'EUR' }
  end
end
