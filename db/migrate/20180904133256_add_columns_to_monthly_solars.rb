class AddColumnsToMonthlySolars < ActiveRecord::Migration[5.2]
  def change
    add_column :monthly_solars, :prev_month_rate, :float
    add_column :monthly_solars, :prev_year_rate, :float
    add_column :monthly_solars, :estimate_remains_kwh, :decimal, precision: 16, scale: 4
    add_column :monthly_solars, :estimate_kwh, :decimal, precision: 16, scale: 4
    add_column :monthly_solars, :neighbor_solar_radiation, :float
    add_column :monthly_solars, :prev_year_neighbor_solar_radiation, :float
    add_column :monthly_solars, :kwh_per_day, :float
    add_column :monthly_solars, :kwh_per_day_per_unit, :float
    add_column :monthly_solars, :mixed_kwh, :decimal, precision: 16, scale: 4
  end
end
