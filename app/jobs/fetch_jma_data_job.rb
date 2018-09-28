class FetchJmaDataJob < ApplicationJob
  queue_as :default

  def perform(*args)
    date_param = args[0]
    @target_date = if date_param.present?
                     Date.parse(date_param)
                   else
                     Date.yesterday
                   end
    @target_month = @target_date.strftime('%Y%m')
    puts "execute fetch jma data job. target_date=#{@target_date}, target_month=#{@target_month}"
    Facility.all.each do |facility|  
      if facility.jma_place
        fetch_jma_data(facility)
      end
    end
  end

  private

  def fetch_jma_data(facility)
    jma_place = facility.jma_place
    site_url = 'http://www.data.jma.go.jp' 
    path = "/obd/stats/etrn/view/daily_s1.php?prec_no=#{jma_place.prec_no}&block_no=#{jma_place.block_no}&year=#{@target_date.year}&month=#{@target_date.month}&day=&view=a3"
    connection = Faraday.new(url: site_url)
    res = connection.get(path)
    results = JmaParser.parse(res.body.force_encoding('utf-8'), jma_place)

    if results.present?
      monthly_data = JmaMonthlySolarRadiation.find_or_initialize_by(jma_place: jma_place, year_month: @target_month)
      monthly_data.average_value = results.map(&:value).compact.sum / results.count
      monthly_data.save!

      DailySolar.update_solar_radiations!(facility, results)
      MonthlySolar.update_solar_radiation!(facility, monthly_data)
    end
  end
end
