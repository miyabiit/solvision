class NedoParser
  class << self
    def parse(text)
      result = {}
      place = nil
      solar_radiations = []
      text.each_line.with_index do |line, index|
        if index == 0
          columns = line.split(/\s+/)
          result[:number] = columns[1]
          result[:name] = columns[2]
          if result[:name].blank? || result[:number].blank?
            raise 'Parse Error'
          end
          place = NedoPlace.find_or_initialize_by(number: result[:number], name: result[:name])
          if columns[3].present? && columns[4].present?
            place.latitude = BigDecimal(columns[3]) + (BigDecimal(columns[4]) / BigDecimal('60'))
          end
          if columns[5].present? && columns[6].present?
            place.longitude = BigDecimal(columns[5]) + (BigDecimal(columns[6]) / BigDecimal('60'))
          end
          if columns[7].present?
            place.elevation = BigDecimal(columns[7])
          end
          place.save!
        elsif [1,2,3].include?(index)
          if place.blank?
            raise 'No Place'
          end
          line = line[11..-1]
          case index
          when 1
            solar_radiations = (1..12).map {|month| NedoSolarRadiation.find_or_initialize_by(nedo_place_id: place.id, month: month)}
            (1..12).each do |month|
              solar_radiations[month-1].average_value = BigDecimal(line[(month*6), 6])
            end
          when 2
            (1..12).each do |month|
              solar_radiations[month-1].maximum_value = BigDecimal(line[(month*6), 6])
            end
          when 3
            (1..12).each do |month|
              solar_radiations[month-1].minimum_value = BigDecimal(line[(month*6), 6])
            end
          end
        else
          break
        end
      end
      solar_radiations.each(&:save!)
      solar_radiations
    end
  end
end
