class CompactString < ActiveRecord::Type::String
  def initialize(strip: false)
    @is_strip = strip
  end

  def cast_value(value)
    value = value&.to_s&.strip if @is_strip
    value&.to_s&.gsub(/\R/, "\n")
  end
end
