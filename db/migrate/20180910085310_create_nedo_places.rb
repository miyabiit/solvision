class CreateNedoPlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :nedo_places do |t|
      t.integer :number
      t.string :name, null: false
      t.decimal :latitude, precision: 12, scale: 8, null: false
      t.decimal :longitude, precision: 12, scale: 8, null: false
      t.decimal :elevation, precision: 8, scale: 2
    end
  end
end
