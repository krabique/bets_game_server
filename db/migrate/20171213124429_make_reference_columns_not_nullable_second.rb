# frozen_string_literal: true

class MakeReferenceColumnsNotNullableSecond < ActiveRecord::Migration[5.1]
  def change
    change_column :bets, :account_id, :bigint, null: false
  end
end
