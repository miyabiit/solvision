class CreateReceipts < ActiveRecord::Migration[5.2]
  def change
    create_table :receipts do |t|
      t.references :monthly_receipt, foreign_key: true, null: false, index: true
      t.integer :amount, limit: 8, null: false, default: 0
      t.date :receipt_date
      t.string :receipt_from

      t.timestamps
    end
  end
end
