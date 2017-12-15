# frozen_string_literal: true

class AddMultiplierToBets < ActiveRecord::Migration[5.1]
  def change
    add_column :bets, :multiplier, :integer, null: false, default: -1
  end
end
