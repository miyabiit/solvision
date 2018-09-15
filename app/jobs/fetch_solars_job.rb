class FetchSolarsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    date_param = args[0]
    @target_date = if date_param.present?
                     Date.parse(date_param)
                   else
                     Date.yesterday
                   end
    @target_month = @target_date.strftime('%Y%m')
    puts "execute fetch solars job. target_date=#{@target_date}, target_month=#{@target_month}"
    facilities = Facility.all
    facilities.each do |facility|
      update_daily_solar(facility)
      update_monthly_solar(facility)
    end
  end

  private

  def update_monthly_solar(facility)
    monthly_solar = MonthlySolar.find_or_initialize_by(facility_id: facility.id, month: @target_month)
    solar_monthly_solars = SolarMonthlySolar.where(facility_id: facility.facility_aliases.map(&:solar_facility_id), from: @target_month, to: @target_month).to_a
    target_month_date = @target_date.beginning_of_month
    sum_kwh = solar_monthly_solars.map(&:total_kwh).sum.presence || 0
    if sum_kwh == 0
      monthly_solar.kwh = DailySolar.where(facility: facility, date: (target_month_date .. target_month_date.end_of_month)).sum(:kwh)
    else
      monthly_solar.kwh = sum_kwh
    end

    prev_month_monthly_solar = MonthlySolar.where(facility: facility, month: target_month_date.prev_month.strftime('%Y%m')).first
    prev_year_monthly_solar = MonthlySolar.where(facility: facility, month: target_month_date.prev_year.strftime('%Y%m')).first
    monthly_solar.calculate(
      prev_month_monthly_solar,
      prev_year_monthly_solar,
      DailySolar.where(facility: facility, date: (monthly_solar.month_date .. monthly_solar.month_date.end_of_month)).count
    )

    monthly_solar.save!
  end

  def update_daily_solar(facility)
    solar_daily_solars = SolarDailySolar.where(facility_id: facility.facility_aliases.map(&:solar_facility_id), from: @target_date.beginning_of_month.strftime('%Y%m%d'), to: @target_date.end_of_month.strftime('%Y%m%d'))
    solar_daily_solars.group_by(&:date).each do |date, solar_daily_solar|
      daily_solar = DailySolar.find_or_initialize_by(facility: facility, date: date)
      daily_solar.kwh = solar_daily_solar.map(&:total_kwh).sum
      daily_solar.save!
    end
  end
end
