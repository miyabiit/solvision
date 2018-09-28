class JmaPlace < ApplicationRecord
  has_many :jma_daily_solar_radiations, dependent: :destroy
  has_many :jma_monthly_solar_radiations, dependent: :destroy
  has_one :facility

  def month_rate(year_date)
    month_value = jma_monthly_solar_radiations.find_by(year_month: year_date.strftime('%Y%m'))&.value
    year_sum_value = jma_monthly_solar_radiations.where(year_month: ("#{year_date.year}01" .. "#{year_date.year}12")).sum(:value)
    month_value / year_sum_value
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
