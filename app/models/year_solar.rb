class YearSolar
  include ActiveAttr::Model

  attribute :facility
  attribute :year_date
  attribute :kwh
  attribute :mixed_kwh
  attribute :estimate_remains_kwh
  attribute :mixed_monthly_solars

  def calculate
    calculate_mixed_monthly_solars
    self.kwh = mixed_monthly_solars.map(&:kwh).compact.sum
    self.mixed_kwh = mixed_monthly_solars.map(&:mixed_kwh).compact.sum
    self.estimate_remains_kwh = mixed_monthly_solars.map(&:estimate_remains_kwh).compact.sum
  end

  def calculate_mixed_monthly_solars
    self.mixed_monthly_solars = monthly_solars.to_a
    prev_year_monthly_solars = MonthlySolar.where(facility: facility, month: (year_date.prev_year.strftime('%Y%m') .. year_date.prev_year.end_of_year.strftime('%Y%m'))).order(:month).to_a
    months = monthly_solars.map {|ms| ms.month_date.month }
    ((1..12).to_a - months).each do |remains_month|
      target_date = Date.new(year_date.year, remains_month, 1)
      prev_year = target_date.prev_year.strftime('%Y%m')
      prev_year_monthly_solar = prev_year_monthly_solars.find {|ms| ms.month == prev_year }
      ms = MonthlySolar.new(facility: facility, month: target_date.strftime('%Y%m'))
      prev_year_monthly_solar.kwh = prev_year_monthly_solar.mixed_kwh if prev_year_monthly_solar
      prev_month_solar = mixed_monthly_solars.find {|ms2| ms2.month == ms.month_date.prev_month.strftime('%Y%m')} || MonthlySolar.where(facility: ms.facility, month: ms.month_date.prev_month.strftime('%Y%m')).first 
      prev_month_solar.kwh = prev_month_solar.mixed_kwh if prev_month_solar
      ms.calculate(prev_month_solar, prev_year_monthly_solar, 0)
      self.mixed_monthly_solars << ms
    end
    self.mixed_monthly_solars.sort_by!(&:month)
  end

  def monthly_solars
    year_month_from = year_date.beginning_of_year.strftime('%Y%m')
    year_month_to = year_date.end_of_year.strftime('%Y%m')
    facility.monthly_solars.where(month: (year_month_from .. year_month_to))
  end

  class << self
    def generate(facility, year_first_date)
      instance = new(facility: facility, year_date: year_first_date.beginning_of_year)
      instance.calculate
      instance
    end
  end
end
