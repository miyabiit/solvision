class AddNumbersToJmaPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :jma_places, :prec_no, :integer
    add_column :jma_places, :block_no, :integer
  end
end
