class FacilityTotalSolar
  include ActiveAttr::Model

  attribute :month
  attribute :estimate_kwh
  attribute :mixed_kwh

  class << self
    def generate(year_first_date)
      year_date = year_first_date.beginning_of_year
      year_month_from = year_date.beginning_of_year.strftime('%Y%m')
      year_month_to = year_date.end_of_year.strftime('%Y%m')
      mixed_kwh_per_month = MonthlySolar.where(month: (year_month_from .. year_month_to)).group(:month).sum(:mixed_kwh)
      estimate_kwh_per_month = MonthlySolar.where(month: (year_month_from .. year_month_to)).group(:month).sum(:estimate_kwh)
      months = mixed_kwh_per_month.keys

      months.map do |month|
        new(month: month, mixed_kwh: mixed_kwh_per_month[month], estimate_kwh: estimate_kwh_per_month[month])
      end
    end
  end
end
