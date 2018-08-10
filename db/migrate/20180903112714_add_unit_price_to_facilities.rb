class AddUnitPriceToFacilities < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities, :unit_price, :integer, default: 0, null: false
  end
end
