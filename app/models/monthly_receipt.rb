class MonthlyReceipt < ApplicationRecord
  belongs_to :facility

  has_many :receipts, dependent: :destroy
  
  validates :year_month, :amount, presence: true
  validates :year_month, format: { with: /\A\d{6}\z/ }
  validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def update_amount!
    update_attributes!(amount: receipts.map(&:amount).sum)
  end
end
