class RenameValueToJmaMonthlySolarRadiations < ActiveRecord::Migration[5.2]
  def change
    rename_column :jma_monthly_solar_radiations, :value, :average_value
  end
end
