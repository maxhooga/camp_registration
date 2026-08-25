require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  setup do
    @camp = Camp.create!(name: "Test camp", capacity: 5)
  end

  test "requires guest name, amount and dates" do
    reservation = @camp.reservations.new

    assert_not reservation.valid?
    assert_includes reservation.errors[:name], "can't be blank"
    assert_includes reservation.errors[:amount], "can't be blank"
    assert_includes reservation.errors[:start_date], "can't be blank"
    assert_includes reservation.errors[:end_date], "can't be blank"
  end

  test "end date must be after start date" do
    reservation = @camp.reservations.new(
      name: "Guest",
      amount: 1,
      start_date: Date.new(2026, 8, 10),
      end_date: Date.new(2026, 8, 10)
    )

    assert_not reservation.valid?
    assert_includes reservation.errors[:end_date], "must be after start date"
  end

  test "rejects a booking that would exceed capacity on overlapping dates" do
    @camp.reservations.create!(
      name: "First",
      amount: 4,
      start_date: Date.new(2026, 8, 1),
      end_date: Date.new(2026, 8, 10)
    )

    reservation = @camp.reservations.new(
      name: "Second",
      amount: 2,
      start_date: Date.new(2026, 8, 5),
      end_date: Date.new(2026, 8, 8)
    )

    assert_not reservation.save
    assert_includes reservation.errors[:base], "would exceed camp capacity for these dates"
  end

  test "allows a booking when overlapping occupancy stays within capacity" do
    @camp.reservations.create!(
      name: "First",
      amount: 3,
      start_date: Date.new(2026, 8, 1),
      end_date: Date.new(2026, 8, 10)
    )

    reservation = @camp.reservations.new(
      name: "Second",
      amount: 2,
      start_date: Date.new(2026, 8, 5),
      end_date: Date.new(2026, 8, 8)
    )

    assert reservation.save
  end

  test "updating a reservation ignores its own previous occupancy" do
    reservation = @camp.reservations.create!(
      name: "Guest",
      amount: 5,
      start_date: Date.new(2026, 8, 1),
      end_date: Date.new(2026, 8, 10)
    )

    reservation.amount = 4

    assert reservation.save
  end
end
