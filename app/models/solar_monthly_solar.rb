class SolarMonthlySolar < SolarsAPIModel
  resource_path '/api/monthly_solars'

  attribute :_id
  attribute :facility_id
  attribute :total_kwh,     type: Integer
  attribute :sales,         type: Integer
  attribute :month
  attribute :date_time,     type: DateTime
  attribute :site_status
end
