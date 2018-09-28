class CreateNedoSolarRadiations < ActiveRecord::Migration[5.2]
  def change
    create_table :nedo_solar_radiations do |t|
      t.references :nedo_place, null: false, index: true, foreign_key: true
      t.integer :month, null: false
      t.decimal :average_value, precision: 6, scale: 2, null: false
      t.decimal :minimum_value, precision: 6, scale: 2, null: false
      t.decimal :maximum_value, precision: 6, scale: 2, null: false
    end
  end
end
