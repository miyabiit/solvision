class FacilityCapacity < ApplicationRecord
  belongs_to :facility

  scope :last_capacity, -> { order(date: :desc).limit(1) }
end
