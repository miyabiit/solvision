class SolarFacility < SolarsAPIModel
  resource_path '/api/facilities'

  attribute :_id
  attribute :_type
  attribute :name
  attribute :disp_name
  attribute :unit_price
  attribute :order_num

  def attributes_for_option
    [name, _id]
  end
end
