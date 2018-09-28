class AddGeometoryToFacilities < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities, :latitude, :decimal, precision: 12, scale: 8
    add_column :facilities, :longitude, :decimal, precision: 12, scale: 8
    remove_column :facilities, :geocode, :string
  end
end
