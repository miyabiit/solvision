class MonthlySolar < ApplicationRecord
  belongs_to :facility

  validates :kwh, :solar_radiation, numericality: {greater_than_or_equal_to: 0, allow_blank: true }
  validates :month, format: { with: /\A\d{6}\z/, allow_blank: true }

  #attribute :prev_month_rate
  #attribute :prev_year_rate
  #attribute :estimate_remains_kwh
  #attribute :estimate_kwh
  #attribute :kwh_per_day
  #attribute :kwh_per_day_per_unit
  #attribute :mixed_kwh

  DEGRADE_RATE = 0.993

  def prev_year
    self.class.find_by(facility: facility, month: month_date.prev_year.strftime('%Y%m'))
  end

  def month_date
    Date.strptime(month, '%Y%m')
  end

  def calculate(prev_month_data, prev_year_data, days)
    target_date = Date.strptime(month, '%Y%m')
    month_days = target_date.end_of_month.day
    remains_days = month_days - days
    last_capacity = facility.facility_capacities.where(date: (Date.new(1970, 1, 1) .. target_date)).last_capacity.first
    unless last_capacity
      last_capacity = facility.facility_capacities.order(date: :asc).first
    end
    prev_year_last_capacity = facility.facility_capacities.where(date: (Date.new(1970, 1, 1) .. target_date.prev_year)).last_capacity.first
    unless prev_year_last_capacity
      prev_year_last_capacity = last_capacity
    end
    if last_capacity
      if prev_year_data&.kwh
        if prev_year_last_capacity.value > 0
          self.estimate_kwh = (prev_year_data.kwh.to_f * last_capacity.value / prev_year_last_capacity.value * DEGRADE_RATE)
        end
      elsif facility.nedo_place && facility.jma_place
        # NEDO 予測から推定 # TODO: 計算式未定
        #self.estimate_kwh =
        #  facility.nedo_place.kwh_by_month(month_days, last_capacity.value) * (facility.jma_place.month_rate(target_date.prev_year))
      end
    end
    self.kwh_per_day = (kwh.to_f / days) if days > 0
    self.kwh_per_day_per_unit = (kwh_per_day / last_capacity.value) if kwh_per_day && last_capacity&.value && last_capacity.value > 0
    if remains_days > 0
      if estimate_kwh && estimate_kwh > 0
        self.estimate_remains_kwh = (estimate_kwh / month_days * remains_days)
      end
    else
      self.estimate_remains_kwh = nil
    end
    self.mixed_kwh = (kwh || 0) + (estimate_remains_kwh || 0)
    if mixed_kwh > 0
      if prev_month_data&.kwh && prev_month_data.kwh > 0
        self.prev_month_rate = (mixed_kwh.to_f / (prev_month_data.mixed_kwh || prev_month_data.kwh) * 100)
      end
      if prev_year_data&.kwh && prev_year_data.kwh > 0
        self.prev_year_rate = (mixed_kwh.to_f / (prev_year_data.mixed_kwh || prev_year_data.kwh) * 100)
      end
    end
  end

  class << self
    def update_solar_radiation!(facility, monthly_radiation)
      monthly_solar = find_or_initialize_by(facility: facility, month: monthly_radiation.year_month)
      monthly_solar.solar_radiation = monthly_radiation.average_value
      if prev_year_monthly_solar = monthly_solar.prev_year
        monthly_solar.prev_year_solar_radiation = prev_year_monthly_solar.solar_radiation
      end
      monthly_solar.save!
    end
  end
end
