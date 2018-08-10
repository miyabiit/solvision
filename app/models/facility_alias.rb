class FacilityAlias < ApplicationRecord
  belongs_to :facility, optional: true

  validates :solar_facility_id, uniqueness: true
end
