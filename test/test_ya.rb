require 'test/unit'
require './Ya'

class TestYa < Test::Unit::TestCase

  def setup
    @ya = Ya.new
  end

  def test_ya_number
    assert_equal(@ya.eval(1), 1)
  end

end

