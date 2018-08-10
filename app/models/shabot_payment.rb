class ShabotPayment < ShabotAPIModel
  resource_path '/api/payments'

  attribute :id,            type: Integer
  attribute :slip_no,       type: Integer
  attribute :planned,       type: Boolean
  attribute :project
  attribute :payment_date,  type: Date
  attribute :payment_to
  attribute :comment
  attribute :total_amount,  type: Integer
  attribute :created_at
  attribute :updated_at
end
