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

  def calendar_weeks(month_start)
    month_start = month_start.to_date.beginning_of_month
    month_end = month_start.next_month
    timeline = occupancy_timeline(
      reservations.where("start_date < ? AND end_date > ?", month_end, month_start)
    )

    current = 0
    full = false
    index = 0

    while index < timeline.length && timeline[index][:date] < month_start
      current = timeline[index][:current]
      full = timeline[index][:full]
      index += 1
    end

    cells = Array.new(month_start.cwday - 1)
    (month_start...month_end).each do |date|
      while index < timeline.length && timeline[index][:date] == date
        current = timeline[index][:current]
        full = timeline[index][:full]
        index += 1
      end
      cells << { date: date, occupied: current, full: full }
    end
    cells.concat(Array.new((7 - cells.size % 7) % 7))
    cells.each_slice(7).to_a
  end
end
