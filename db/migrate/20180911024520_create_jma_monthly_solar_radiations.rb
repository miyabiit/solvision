class CreateJmaMonthlySolarRadiations < ActiveRecord::Migration[5.2]
  def change
    create_table :jma_monthly_solar_radiations do |t|
      t.references :jma_place, index: true, null: false, foreign_key: true
      t.string :year_month, null: false
      t.decimal :value, precision: 8, scale: 2
    end
  end
end
