class FacilityProject < ApplicationRecord
  belongs_to :facility, optional: true

  validates :shabot_project_name, :shabot_project_category, presence: true
end
