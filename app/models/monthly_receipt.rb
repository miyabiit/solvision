class MonthlyReceipt < ApplicationRecord
  belongs_to :facility
  
  validates :year_month, :amount, presence: true
  validates :year_month, format: { with: /\A\d{6}\z/ }
  validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
