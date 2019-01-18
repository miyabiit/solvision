class AddInputKwhToMonthlySolars < ActiveRecord::Migration[5.2]
  def change
    add_column :monthly_solars, :input_kwh_enabled, :boolean
    add_column :monthly_solars, :input_kwh, :decimal, precision: 16, scale: 4
  end
end
