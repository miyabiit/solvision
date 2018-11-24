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

      if months.present?
        months.sort.map do |month|
          new(month: month, mixed_kwh: mixed_kwh_per_month[month], estimate_kwh: estimate_kwh_per_month[month])
        end
      else
        generate_by_prev_year(year_first_date)
      end
    end

    def generate_by_prev_year(year_first_date)
      year_date = year_first_date.prev_year.beginning_of_year
      year_month_from = year_date.beginning_of_year.strftime('%Y%m')
      year_month_to = year_date.end_of_year.strftime('%Y%m')
      prev_year_monthly_solars = MonthlySolar.where(month: (year_month_from .. year_month_to)).to_a
      return [] if prev_year_monthly_solars.blank?
      monthly_solars = prev_year_monthly_solars.map do |prev_year_ms|
        prev_year_ms.kwh = prev_year_ms.mixed_kwh
        ms = MonthlySolar.new(facility: prev_year_ms.facility, month: Date.strptime(prev_year_ms.month, '%Y%m').next_year.strftime('%Y%m'))
        ms.calculate(nil, prev_year_ms, 0)
        ms
      end
      year_total_solars = monthly_solars.group_by(&:month).map do |month, ms|
        new(month: month, mixed_kwh: ms.map(&:mixed_kwh).compact.sum, estimate_kwh: ms.map(&:estimate_kwh).compact.sum)
      end
      year_total_solars.sort_by(&:month)
    end
  end
end
