# frozen_string_literal: true

class ChangeMoneyColumnsToBigint < ActiveRecord::Migration[5.1]
  def change
    change_column :bets, :bet_amount_cents, :integer, limit: 8
    change_column :bets, :win_amount_cents, :integer, limit: 8

    change_column :accounts, :amount_cents, :integer, limit: 8
  end
end
