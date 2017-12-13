class MakeReferenceColumnsNotNullable < ActiveRecord::Migration[5.1]
  def change
    change_column :accounts, :user_id, :bigint, null: false
  end
  
  # more in next migration
end
