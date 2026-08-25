require "test_helper"

class CapacityCheckTest < ActiveSupport::TestCase
  test "empty intervals always fit" do
    assert CapacityCheck.fits?([], 1)
  end

  test "a single booking within capacity fits" do
    assert CapacityCheck.fits?([ [ 10, 20, 1 ] ], 1)
  end

  test "adjacent intervals do not overlap" do
    assert CapacityCheck.fits?([ [ 0, 8, 1 ], [ 8, 10, 1 ] ], 1)
  end

  test "overlapping intervals above capacity are rejected" do
    assert_not CapacityCheck.fits?([ [ 0, 30, 1 ], [ 5, 10, 1 ] ], 1)
  end

  test "staggered intervals are not all concurrent" do
    intervals = [ [ 1, 5, 1 ], [ 6, 10, 1 ], [ 1, 10, 1 ] ]

    assert CapacityCheck.fits?(intervals, 2)
    assert_not CapacityCheck.fits?(intervals, 1)
  end

  test "amount is how many spots a reservation occupies" do
    intervals = [ [ 1, 10, 4 ], [ 5, 12, 4 ] ]

    assert CapacityCheck.fits?(intervals, 8)
    assert_not CapacityCheck.fits?(intervals, 7)
  end

  test "checkout on the same day frees amount before the next arrival" do
    intervals = [ [ 1, 5, 10 ], [ 5, 10, 10 ] ]

    assert CapacityCheck.fits?(intervals, 10)
  end
end
