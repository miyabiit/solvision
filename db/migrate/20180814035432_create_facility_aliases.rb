class CreateFacilityAliases < ActiveRecord::Migration[5.2]
  def change
    create_table :facility_aliases do |t|
      t.references :facility, index: true, null: false, foreign_key: true
      t.string :solar_facility_id
      t.string :solar_facility_name

      t.timestamps

      t.index :solar_facility_id, unique: true
    end
  end
end
