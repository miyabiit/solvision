class AddUnitCountToFacilityCapacities < ActiveRecord::Migration[5.2]
  def change
    add_column :facility_capacities, :unit_count, :integer, default: 0, null: false
  end
end
