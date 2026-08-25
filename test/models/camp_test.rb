require "test_helper"

class CampTest < ActiveSupport::TestCase
  test "requires a name and a positive capacity" do
    camp = Camp.new

    assert_not camp.valid?
    assert_includes camp.errors[:name], "can't be blank"
    assert_includes camp.errors[:capacity], "can't be blank"

    camp.assign_attributes(name: "Pine", capacity: 0)

    assert_not camp.valid?
    assert_includes camp.errors[:capacity], "must be greater than 0"
  end
end
