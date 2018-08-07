class CreateMonthlyReceipts < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_receipts do |t|
      t.references :facility, foreign_key: true, null: false
      t.string :year_month, null: false
      t.integer :amount, limit: 8, null: false, default: 0
      
      t.timestamps
    end
  end
end
