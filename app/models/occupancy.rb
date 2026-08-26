class Occupancy
  def self.timeline(intervals)
    events = intervals.flat_map do |interval|
      [ [ interval.start_date, interval.amount ], [ interval.end_date, -interval.amount ] ]
    end
    events.sort_by! { |date, delta| [ date, delta ] }

    current = 0
    events.map do |date, delta|
      current += delta
      { date: date, current: current }
    end
  end
end
