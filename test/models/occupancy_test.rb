require "test_helper"

class OccupancyTest < ActiveSupport::TestCase
  Interval = Struct.new(:start_date, :end_date, :amount)

  test "adjacent intervals do not overlap" do
    intervals = [
      Interval.new(Date.new(2026, 8, 1), Date.new(2026, 8, 5), 5),
      Interval.new(Date.new(2026, 8, 5), Date.new(2026, 8, 10), 5)
    ]

    assert Occupancy.timeline(intervals).none? { |point| point[:current] > 5 }
  end

  test "staggered stays are not all concurrent" do
    intervals = [
      Interval.new(Date.new(2026, 8, 1), Date.new(2026, 8, 5), 4),
      Interval.new(Date.new(2026, 8, 6), Date.new(2026, 8, 10), 4),
      Interval.new(Date.new(2026, 8, 1), Date.new(2026, 8, 10), 1)
    ]

    assert Occupancy.timeline(intervals).none? { |point| point[:current] > 5 }
    assert Occupancy.timeline(intervals).any? { |point| point[:current] == 5 }
  end
end
