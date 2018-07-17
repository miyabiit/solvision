class Facility < ApplicationRecord
  extend Enumerize

  has_many :facility_capacities, dependent: :destroy

  validates :name, presence: true
  validates :capacity_date, presence: true, if: ->(this) { this.capacity_value.present? }
  validate :capacity_date_is_not_past, if: ->(this) { this.capacity_date.present? }

  attribute :capacity_value, :integer
  attribute :capacity_date, :date

  after_save :update_capacities

  enumerize :sales_type, in: {normal: 0, premium: 1}

  def last_capacity
    facility_capacities.last_capacity.first
  end

  def load_last_capacity
    self.capacity_value = last_capacity&.value
    self.capacity_date = last_capacity&.date
  end

  private

  def update_capacities
    if capacity_value.blank? || capacity_date.blank?
      return
    end
    if last_capacity&.value != capacity_value
      if last_capacity&.date != capacity_date
        # add
        self.facility_capacities << FacilityCapacity.new(value: capacity_value, date: capacity_date)
      else
        # update
        last_capacity.update_attributes(value: capacity_value)
      end
    elsif last_capacity&.date != capacity_date
      last_capacity.update_attributes(date: capacity_date)
    end
  end

  def capacity_date_is_not_past
    if facility_capacities.where('facility_capacities.date > ?', capacity_date).exists?
      errors.add :capacity_date, 'は過去の日付です'
    end
  end
end
