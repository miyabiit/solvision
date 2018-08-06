class Receipt < ApplicationRecord
  belongs_to :monthly_receipt
  
  attribute :receipt_from, CompactString.new(strip: true)

  validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
