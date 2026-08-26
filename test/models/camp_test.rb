require "test_helper"

class CampTest < ActiveSupport::TestCase
  test "calendar marks occupied days full from occupancy timeline" do
    camp = Camp.create!(name: "Test", capacity: 2)
    start_date = Date.new(2026, 8, 10)
    camp.reservations.create!(
      name: "Full stay",
      amount: 2,
      start_date: start_date,
      end_date: start_date + 2
    )

    days = camp.calendar_weeks(start_date).flatten.compact.index_by { |cell| cell[:date] }

    assert days[start_date][:full]
    assert days[start_date + 1][:full]
    assert_not days[start_date + 2][:full]
    assert_not days[start_date - 1][:full]
  end
end
