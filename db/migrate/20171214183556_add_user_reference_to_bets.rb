class AddUserReferenceToBets < ActiveRecord::Migration[5.1]
  def change
    add_reference :bets, :user, foreign_key: true
  end
end
