class ChangeColumnsToMonthlyReceipts < ActiveRecord::Migration[5.2]
  def change
    remove_column :monthly_receipts, :receipt_date, :date
    remove_column :monthly_receipts, :receipt_from, :string
  end
end
