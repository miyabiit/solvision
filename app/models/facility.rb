class Facility < ApplicationRecord
  extend Enumerize

  has_many :facility_capacities, dependent: :destroy
  has_many :facility_aliases, dependent: :destroy, inverse_of: :facility
  has_many :facility_projects, dependent: :destroy, inverse_of: :facility
  has_many :monthly_solars, dependent: :destroy
  has_many :daily_solars, dependent: :destroy
  has_many :monthly_receipts, dependent: :destroy

  validates :name, presence: true
  validates :capacity_date, presence: true, if: ->(this) { this.capacity_value.present? }
  validates :capacity_unit_count, presence: true, if: ->(this) { this.capacity_value.present? }
  validates :capacity_value, numericality: { greater_than_or_equal_to: 0, allow_blank: true }
  validates :capacity_unit_count, numericality: { greater_than_or_equal_to: 0, allow_blank: true, only_integer: true }
  validate :capacity_date_is_not_past, if: ->(this) { this.capacity_date.present? }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0, allow_blank: true, only_integer: true }

  attribute :capacity_value, :integer
  attribute :capacity_date, :date
  attribute :capacity_unit_count, :integer

  before_save :set_solar_facility_name
  after_save :update_capacities

  enumerize :sales_type, in: {normal: 0, premium: 1}

  accepts_nested_attributes_for :facility_aliases, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :facility_projects, allow_destroy: true, reject_if: :all_blank

  CONSUMPTION_TAX = 1.08

  attr_accessor :solar_facilities

  def last_capacity
    facility_capacities.last_capacity.first
  end

  def load_last_capacity
    self.capacity_value = last_capacity&.value
    self.capacity_date = last_capacity&.date
    self.capacity_unit_count = last_capacity&.unit_count
  end

  def kwh_to_sales(kwh)
    if sales_type.premium?
      (kwh.to_f * 0.5 * unit_price + kwh * 0.5 * (unit_price + 1)) * CONSUMPTION_TAX
    else
      kwh.to_f * unit_price * CONSUMPTION_TAX
    end
  end

  private

  def update_capacities
    if capacity_value.blank? || capacity_date.blank? || capacity_unit_count.blank?
      return
    end
    if last_capacity&.value != capacity_value || last_capacity&.unit_count != capacity_unit_count
      if last_capacity&.date != capacity_date
        # add
        self.facility_capacities << FacilityCapacity.new(value: capacity_value, date: capacity_date, unit_count: capacity_unit_count)
      else
        # update
        last_capacity.update_attributes(value: capacity_value, unit_count: capacity_unit_count)
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

  def set_solar_facility_name
    if solar_facilities.present? && facility_aliases.present?
      facility_aliases.each do |fa|
        if fa.solar_facility_name.blank?
          fa.solar_facility_name = solar_facilities.find { |sf| sf._id == fa.solar_facility_id }&.name
        end
      end
    end
  end
end
