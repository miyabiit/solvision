class AddColumnsToMonthlyReceipts < ActiveRecord::Migration[5.2]
  def change
    add_column :monthly_receipts, :receipt_date, :date
    add_column :monthly_receipts, :receipt_from, :string
  end
end
