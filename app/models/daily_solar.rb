class DailySolar < ApplicationRecord
  belongs_to :facility

  validates :kwh, :solar_radiation, numericality: {greater_than_or_equal_to: 0, allow_blank: true }

  attribute :estimate_kwh

  class << self
    def update_solar_radiations!(facility, daily_radiations)
      daily_radiations.each do |daily_radiation|
        daily_solar = find_or_initialize_by(facility: facility, date: daily_radiation.date)
        daily_solar.solar_radiation = daily_radiation.value
        daily_solar.save!
      end
    end
  end
end
