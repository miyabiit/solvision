class NedoPlace < ApplicationRecord
  has_many :nedo_solar_radiations, dependent: :destroy
  has_one :facility

  K_PARAM = 0.756

  def kwh_by_month(days, capacity_value)
    nedo_solar_radiations.sum(:average_value) * K_PARAM * days * capacity_value
  end

  class << self
    def options
      all.pluck(:name, :id)
    end

    def nearest(latitude, longitude)
      all.min_by {|p| ((latitude - p.latitude) ** 2) + ((longitude - p.longitude) ** 2)}
    end
  end
end
