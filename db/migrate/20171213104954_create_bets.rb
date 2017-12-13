# frozen_string_literal: true

class CreateBets < ActiveRecord::Migration[5.1]
  def change
    create_table :bets do |t|
      t.monetize :bet_amount
      t.monetize :win_amount

      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
