require 'nokogiri'

class JmaParser

  SOLAR_RAD_IDX = 10
  DATE_IDX = 0

  class << self
    def parse(html, jma_place)
      doc = Nokogiri::HTML.parse(html)
      target_date = nil
      /(\d+年\d+月)/.match(html) do |m|
        target_date = Date.strptime(m[1], '%Y年%m月')
      end

      unless target_date
        raise '対象日が取得できません'
      end

      results = []

      doc.search('table.data2_s').each do |table|
        table.search('tr.mtx').each do |tr|
          parsing_date = nil
          tr.search('td').each_with_index do |td, index|
            case index
            when DATE_IDX
              td.search('a').each do |a|
                parsing_date = Date.new(target_date.year, target_date.month, a.text.to_i)
              end
            when SOLAR_RAD_IDX
              if parsing_date
                daily_data = JmaDailySolarRadiation.find_or_initialize_by(jma_place: jma_place, date: parsing_date)
                daily_data.value = (BigDecimal(td.text) rescue nil)
                results << daily_data
              end
            end
          end
        end
      end
      results.each(&:save!)
      results
    end
  end
end
