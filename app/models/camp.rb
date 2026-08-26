class Camp < ApplicationRecord
  has_many :reservations, dependent: :destroy

  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def occupancy_timeline(intervals)
    events = intervals.flat_map do |r|
      [[r.start_date, r.amount], [r.end_date, -r.amount]]
    end
    events.sort_by! { |date, delta| [date, delta] }

    current = 0
    events.map do |date, delta|
      current += delta
      {
        date: date,
        current: current,
        full: current >= capacity
      }
    end
  end
end
