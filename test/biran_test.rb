require 'test_helper'

class Biran::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Biran
  end

  test "extension for config tasks should contain period" do
    # assert extension passed with period('.conf') matches '.conf'
    # assert extension passed without perios('conf') matches '.conf'
    skip
  end
end
