class Reservation < ApplicationRecord
  belongs_to :camp
  validate :fits_camp_capacity

  private
  def fits_camp_capacity
    return if camp.blank? || start_date.blank? || end_date.blank? || amount.blank?
    others = camp.reservations
                 .where("start_date < ? AND end_date > ?", end_date, start_date)
    others = others.where.not(id: id) if persisted?
    events = others.flat_map { |r|
      [[r.start_date, r.amount], [r.end_date, -r.amount]]
    }
    events.concat([[start_date, amount], [end_date, -amount]])
    events.sort_by! { |date, delta| [date, delta] }
    occupied = 0
    events.each do |_, delta|
      occupied += delta
      if occupied > camp.capacity
        errors.add(:base, "would exceed camp capacity for these dates")
        break
      end
    end
  end
end
