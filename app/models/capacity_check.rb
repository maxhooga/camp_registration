# Sweep-line occupancy check for half-open date ranges [start_date, end_date).
# Checkout day does not occupy a spot, so adjacent stays may share an end/start date.
class CapacityCheck
  def self.fits?(intervals, capacity)
    events = intervals.flat_map do |start_date, end_date, amount|
      [ [ start_date, amount ], [ end_date, -amount ] ]
    end
    # Negative deltas first on the same date: departures free capacity before arrivals.
    events.sort_by! { |date, delta| [ date, delta ] }

    occupied = 0
    events.each do |_date, delta|
      occupied += delta
      return false if occupied > capacity
    end

    true
  end
end
