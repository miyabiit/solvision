class AnalysisController < ApplicationController
  before_action :authenticate_user!
  before_action :setup_index, only: [:index, :download]

  def index
    @records = @facilities.map { |facility| YearSolar.generate(facility, @target_date) }
  end

  def show
    @facility = Facility.find(params[:facility_id])
    @year = params[:year].to_i
    if params[:month].present?
      show_by_day
    else
      show_by_month
    end
  end

  def download
    @facilities = Facility.all
    @year = params[:year].to_i
    fetch_year_records
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "売電事業シミュレーション#{@year}年度",
          layout: '/layouts/pdf.html.erb',
          template: '/analysis/download.html.erb',
          encording: 'UTF-8',
          orientation: 'Landscape',
          #header: { right: '[page] / [topage]' },
          dpi: 300
      end
    end
  end

  private

  def show_by_day
    @month = params[:month].to_i
    # 日別の統計情報
    @target_date = Date.new(@year, @month, 1)
    to_date = @target_date.end_of_month
    @records = DailySolar.where(facility: @facility, date: (@target_date .. to_date)).order(:date).to_a
    prev_year = (@target_date.prev_year).strftime('%Y%m')
    prev_year_monthly_solar = MonthlySolar.where(facility: @facility, month: prev_year).first
    if @records.empty?
      (@target_date.day .. to_date.day).each do |day|
        target_date = Date.new(@year, @month, day)
        @records << DailySolar.new(facility: @facility, date: target_date)
      end
    elsif @records.last.date.day < to_date.day
      ((@records.last.date + 1).day .. to_date.day).each do |day|
        target_date = Date.new(@year, @month, day)
        @records << DailySolar.new(facility: @facility, date: target_date)
      end
    end
    monthly_solar = MonthlySolar.new(facility: @facility, month: @target_date.strftime('%Y%m'))
    monthly_solar.calculate(nil, prev_year_monthly_solar, 0)
    estimate_kwh_per_day = monthly_solar.estimate_kwh / @target_date.end_of_month.day
    @records.each do |record|
      record.estimate_kwh = estimate_kwh_per_day
    end
    fetch_shabot_payment(fromym: @target_date.strftime('%Y%m'), toym: @target_date.strftime('%Y%m'))
    render 'show_by_day'
  end

  def fetch_shabot_receipt
    @shabot_receipts = []
    year_month = @target_date.strftime('%Y%m')
    @facility.facility_projects.each do |project|
      @shabot_receipts += ShabotReceipt.where(fromym: year_month, toym: year_month, project_name: project.shabot_project_name, project_category: project.shabot_project_category)
    end
  end

  def fetch_year_records
    @records = []
    @records = @facilities.map { |facility| YearSolar.generate(facility, @target_date) }
  end

  def show_by_month
    # 月別の統計情報
    @target_date = Date.new(@year, 1, 1)
    from_month = @target_date.strftime('%Y%m')
    to_month = @target_date.end_of_year.strftime('%Y%m')
    monthly_solars = MonthlySolar.where(facility: @facility, month: ((@target_date.prev_month).strftime('%Y%m') .. to_month)).order(:month).to_a
    prev_year_monthly_solars = MonthlySolar.where(facility: @facility, month: (@target_date.prev_year.strftime('%Y%m') .. @target_date.prev_year.end_of_year.strftime('%Y%m'))).order(:month).to_a

    if monthly_solars.empty? || monthly_solars.last.month != to_month
      start_month = if monthly_solars.present?
                      monthly_solars.last.month_date.month + 1
                    else
                      1
                    end
      (start_month .. 12).each do |month|
        ms = MonthlySolar.new(facility: @facility, month: Date.new(@year, month, 1).strftime('%Y%m'))
        target_date = Date.strptime(ms.month, '%Y%m')
        prev_month = target_date.prev_month.strftime('%Y%m')
        prev_year = target_date.prev_year.strftime('%Y%m')
        ms.calculate(
          monthly_solars.find {|ms2| ms2.month == prev_month },
          prev_year_monthly_solars.find {|ms2| ms2.month == prev_year },
          DailySolar.where(facility: @facility, date: (Date.strptime(ms.month, '%Y%m') .. Date.strptime(ms.month, '%Y%m').end_of_month)).count
        )
        monthly_solars << ms
      end
    end
     
    @records = monthly_solars.select { |ms| (from_month .. to_month).include?(ms.month) }

    fetch_shabot_payment(fromym: from_month, toym: to_month, planned: false)
    @shabot_payments_by_month = @shabot_payments.group_by {|p| p.payment_date.strftime('%Y%m') }

    render 'show_by_month'
  end

  def fetch_shabot_payment(q)
    @shabot_payments = []
    @facility.facility_projects.each do |project|
      @shabot_payments += ShabotPayment.where(q.merge({project_name: project.shabot_project_name, project_category: project.shabot_project_category}))
    end
  end

  def setup_index
    @facilities = Facility.all
    @target_date = if params[:year].present?
                     Date.new(params[:year].to_i, 1, 1)
                   else
                     Date.today
                   end
    @year = @target_date.year
  end
end
