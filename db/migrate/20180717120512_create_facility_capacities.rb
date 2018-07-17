class CreateFacilityCapacities < ActiveRecord::Migration[5.2]
  def change
    create_table :facility_capacities do |t|
      t.references :facility, foreign_key: true
      t.integer :value
      t.date :date

      t.timestamps
    end
  end
end
