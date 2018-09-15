class ShabotReceipt < ShabotAPIModel
  resource_path '/api/receipts'

  attribute :id,              type: Integer
  attribute :receipt_date,    type: Date
  attribute :planned,         type: Boolean
  attribute :amount,          type: Integer
  attribute :comment
  attribute :corporation_code
  attribute :tax_type
  attribute :receipt_from
  attribute :project
  attribute :item
end
