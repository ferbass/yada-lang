require 'test/unit'
require './Ya'

class TestYa < Test::Unit::TestCase

  def setup
    @ya = Ya.new
  end

  def test_ya_number
    assert_equal(@ya.eval(1), 1)
  end

  def test_ya_add
    assert_equal(@ya.eval(['+', 2, 5]), 7)
    assert_equal(@ya.eval(['+', ['+',2, 5], 5]), 12)
    assert_equal(@ya.eval(['+', ['+',2, 5], ['+', 2, 5]]), 14)
  end

  def test_ya_sub
    assert_equal(@ya.eval(['-', 2, 5]), -3)
    assert_equal(@ya.eval(['-', ['-',2, 5], 5]), -8)
    assert_equal(@ya.eval(['-', ['-',2, 5], ['-', 2, 5]]), 0)
  end

  def test_ya_add_sub
    assert_equal(@ya.eval(['-', ['+',2, 5], 5]), 2)
  end

  def test_ya_multi
    assert_equal(@ya.eval(['*', 2, 5]), 10)
    assert_equal(@ya.eval(['*', ['*',2, 5], 5]), 50)
    assert_equal(@ya.eval(['*', ['*',2, 5], ['*', 2, 5]]), 100)
  end

  def test_ya_div
    assert_equal(@ya.eval(['/', 2, 5]), 0)
    assert_equal(@ya.eval(['/', ['/',2, 5], 5]), 0)
  end

  def test_ya_multi_div
    assert_equal(@ya.eval(['/', ['*',2, 5], 5]), 2)
  end

  def test_ya_complex_math
    assert_equal(@ya.eval(['/', ['+', ['*', 2, 5], 5], 5]), 3)
    assert_equal(@ya.eval(['/', ['+', ['*', 2, 5], ['-', 8, 1]], 5]), 3)
  end


  def test_ya_string
    assert_equal(@ya.eval('"a"'), 'a')
  end

end

