class AddPlaceIdToFacilities < ActiveRecord::Migration[5.2]
  def change
    add_reference :facilities, :jma_place, null: true, foreign_key: true
    add_reference :facilities, :nedo_place, null: true, foreign_key: true
  end
end
