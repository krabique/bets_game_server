# frozen_string_literal: true

class MakeUserIdNotNullableInBets < ActiveRecord::Migration[5.1]
  def change
    change_column :bets, :user_id, :bigint, null: false
  end
end
