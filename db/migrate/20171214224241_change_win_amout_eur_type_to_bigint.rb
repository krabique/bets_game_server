# frozen_string_literal: true

class ChangeWinAmoutEurTypeToBigint < ActiveRecord::Migration[5.1]
  def change
    change_column :bets, :win_amount_eur_cents, :integer, limit: 8
  end
end
