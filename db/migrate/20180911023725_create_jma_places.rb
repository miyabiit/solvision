class CreateJmaPlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :jma_places do |t|
      t.string :name, null: false
      t.string :address
      t.decimal :latitude, precision: 12, scale: 8, null: false
      t.decimal :longitude, precision: 12, scale: 8, null: false
    end
  end
end
