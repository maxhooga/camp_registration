require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  setup do
    @camp = Camp.create!(name: "Test camp", capacity: 5)
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

  test "checkout day is free so adjacent stays may both use full capacity" do
    @camp.reservations.create!(
      name: "Leaving",
      amount: 5,
      start_date: Date.new(2026, 8, 1),
      end_date: Date.new(2026, 8, 5)
    )

    reservation = @camp.reservations.new(
      name: "Arriving",
      amount: 5,
      start_date: Date.new(2026, 8, 5),
      end_date: Date.new(2026, 8, 10)
    )

    assert reservation.save
  end

  test "updating a reservation does not count its own previous occupancy twice" do
    reservation = @camp.reservations.create!(
      name: "Guest",
      amount: 5,
      start_date: Date.new(2026, 8, 1),
      end_date: Date.new(2026, 8, 10)
    )

    reservation.amount = 4

    assert reservation.save
  end

  test "rejects a single booking whose amount exceeds camp capacity" do
    reservation = @camp.reservations.new(
      name: "Too many",
      amount: 6,
      start_date: Date.new(2026, 8, 1),
      end_date: Date.new(2026, 8, 3)
    )

    assert_not reservation.save
    assert_includes reservation.errors[:base], "would exceed camp capacity for these dates"
  end

  test "does not treat staggered stays as all concurrent" do
    @camp.reservations.create!(
      name: "Early",
      amount: 4,
      start_date: Date.new(2026, 8, 1),
      end_date: Date.new(2026, 8, 5)
    )
    @camp.reservations.create!(
      name: "Late",
      amount: 4,
      start_date: Date.new(2026, 8, 6),
      end_date: Date.new(2026, 8, 10)
    )

    reservation = @camp.reservations.new(
      name: "Across",
      amount: 1,
      start_date: Date.new(2026, 8, 1),
      end_date: Date.new(2026, 8, 10)
    )

    assert reservation.save
  end
end
