class SolarDailySolar < SolarsAPIModel
  resource_path '/api/daily_solars'

  attribute :_id
  attribute :facility_id
  attribute :total_kwh,   type: Integer
  attribute :site_status
  attribute :sales,       type: Integer
  attribute :date,        type: Date
  attribute :date_time,   type: DateTime
end
