class RemoveEstimateKwhFromMonthlySolars < ActiveRecord::Migration[5.2]
  def change
    remove_column :monthly_solars, :estimate_kwh, :decimal, precision: 16, scale: 4
  end
end
