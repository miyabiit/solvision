class CreateDailySolars < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_solars do |t|
      t.references :facility, null: false, index: true, foreign_key: true
      t.date :date, null: false
      t.decimal :kwh, precision: 16, scale: 4
      t.decimal :solar_radiation, precision: 16, scale: 4

      t.timestamps
    end
  end
end
