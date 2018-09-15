class MonthlySolar < ApplicationRecord
  belongs_to :facility

  validates :kwh, :solar_radiation, numericality: {greater_than_or_equal_to: 0, allow_blank: true }
  validates :month, format: { with: /\A\d{6}\z/, allow_blank: true }

  #attribute :prev_month_rate
  #attribute :prev_year_rate
  #attribute :estimate_remains_kwh
  #attribute :estimate_kwh
  #attribute :neighbor_solar_radiation
  #attribute :prev_year_neighbor_solar_radiation
  #attribute :kwh_per_day
  #attribute :kwh_per_day_per_unit
  #attribute :mixed_kwh

  DEGRADE_RATE = 0.993

  def month_date
    Date.strptime(month, '%Y%m')
  end

  def calculate(prev_month_data, prev_year_data, days)
    target_date = Date.strptime(month, '%Y%m')
    month_days = target_date.end_of_month.day
    remains_days = month_days - days
    last_capacity = facility.facility_capacities.where(date: (Date.new(1970, 1, 1) .. target_date)).last_capacity.first
    prev_year_last_capacity = facility.facility_capacities.where(date: (Date.new(1970, 1, 1) .. target_date.prev_year)).last_capacity.first
    if prev_year_data&.kwh
      if last_capacity
        unless prev_year_last_capacity
          prev_year_last_capacity = last_capacity
        end
        if prev_year_last_capacity.value > 0
          self.estimate_kwh = (prev_year_data.kwh.to_f * last_capacity.value / prev_year_last_capacity.value * DEGRADE_RATE)
        end
      end
    end
    self.kwh_per_day = (kwh.to_f / days) if days > 0
    self.kwh_per_day_per_unit = (kwh_per_day / last_capacity.value) if kwh_per_day && last_capacity&.value && last_capacity.value > 0
    if remains_days > 0 && days > 0
      if estimate_kwh && estimate_kwh > 0
        # TODO: NEDO 予測から推定
        self.estimate_remains_kwh = (estimate_kwh / month_days * remains_days)
      end
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
end
