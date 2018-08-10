class CreateFacilityProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :facility_projects do |t|
      t.references :facility, index: true, null: false, foreign_key: true
      t.string :shabot_project_name
      t.string :shabot_project_category

      t.timestamps
    end
  end
end
