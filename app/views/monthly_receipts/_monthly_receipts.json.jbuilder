json.extract! monthly_receipt, :id, :facility_id, :year_month, :amount, :created_at, :updated_at
json.url monthly_receipt_url(monthly_receipt, format: :json)
