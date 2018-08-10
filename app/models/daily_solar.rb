class DailySolar < ApplicationRecord
  belongs_to :facility

  validates :kwh, :solar_radiation, numericality: {greater_than_or_equal_to: 0, allow_blank: true }

  attribute :estimate_kwh
end
