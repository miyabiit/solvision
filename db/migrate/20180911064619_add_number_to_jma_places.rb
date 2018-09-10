class AddNumberToJmaPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :jma_places, :number, :integer
  end
end
