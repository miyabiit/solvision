class ChangeColumnsToMonthlySolars < ActiveRecord::Migration[5.2]
  def change
    remove_column :monthly_solars, :neighbor_solar_radiation, :float
    rename_column :monthly_solars, :prev_year_neighbor_solar_radiation, :prev_year_solar_radiation
  end
end
