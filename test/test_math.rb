require './test/test_yada.rb'

class TestMath < Test::Unit::TestCase

  def setup
    @yada = Yada.new
  end


  def test_yada_number
    assert_equal(@yada.eval(1), 1)
  end

  def test_yada_add
    assert_equal(@yada.eval(['+', 2, 5]), 7)
    assert_equal(@yada.eval(['+', ['+',2, 5], 5]), 12)
    assert_equal(@yada.eval(['+', ['+',2, 5], ['+', 2, 5]]), 14)
  end

  def test_yada_sub
    assert_equal(@yada.eval(['-', 2, 5]), -3)
    assert_equal(@yada.eval(['-', ['-',2, 5], 5]), -8)
    assert_equal(@yada.eval(['-', ['-',2, 5], ['-', 2, 5]]), 0)
  end

  def test_yada_add_sub
    assert_equal(@yada.eval(['-', ['+',2, 5], 5]), 2)
  end

  def test_yada_multi
    assert_equal(@yada.eval(['*', 2, 5]), 10)
    assert_equal(@yada.eval(['*', ['*',2, 5], 5]), 50)
    assert_equal(@yada.eval(['*', ['*',2, 5], ['*', 2, 5]]), 100)
  end

  def test_yada_div
    assert_equal(@yada.eval(['/', 2, 5]), 0)
    assert_equal(@yada.eval(['/', ['/',2, 5], 5]), 0)
  end

  def test_yada_multi_div
    assert_equal(@yada.eval(['/', ['*',2, 5], 5]), 2)
  end

  def test_yada_complex_math
    assert_equal(@yada.eval(['/', ['+', ['*', 2, 5], 5], 5]), 3)
    assert_equal(@yada.eval(['/', ['+', ['*', 2, 5], ['-', 8, 1]], 5]), 3)
  end

end
