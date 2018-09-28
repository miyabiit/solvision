class CreateJmaDailySolarRadiations < ActiveRecord::Migration[5.2]
  def change
    create_table :jma_daily_solar_radiations do |t|
      t.references :jma_place, index: true, null: false, foreign_key: true
      t.date :date, null: false
      t.decimal :value, precision: 8, scale: 2
    end
  end
end
