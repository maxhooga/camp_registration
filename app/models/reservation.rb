class Reservation < ApplicationRecord
  belongs_to :camp

  validates :name, presence: true
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validate :fits_camp_capacity

  scope :overlapping, ->(start_date, end_date) {
    where("start_date < ? AND end_date > ?", end_date, start_date)
  }

  def to_interval
    [ start_date, end_date, amount ]
  end

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end

  def fits_camp_capacity
    return if camp.blank? || start_date.blank? || end_date.blank? || amount.blank?
    return if camp.accepts?(self)

    errors.add(:base, "would exceed camp capacity for these dates")
  end
end
