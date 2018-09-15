module ApplicationHelper
  def delimited_int(value)
    value&.to_i&.to_s(:delimited)
  end
end
