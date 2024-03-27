require 'test/unit'
require './yada'
require './environment'

class Testyada < Test::Unit::TestCase

  def setup
    env = Environment.new({
      'nil' => nil,
      'false' => false,
      'true' => true,
      'VERSION' => '0.0.1'
    }
    )
    @yada = Yada.new(env)
  end

  # Math
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

  # String
  def test_yada_string
    assert_equal(@yada.eval('"a"'), 'a')
  end

  # Variables
  def test_yada_variable
    #variable declaration
    assert_equal(@yada.eval(['var', 'x', 5]), 5)
    #variable access
    assert_equal(@yada.eval('x'), 5)

    assert_raises(NameError) do
      @yada.eval('y')
    end

    #test prebaked variables
    assert_equal(@yada.eval('VERSION'), '0.0.1')
    assert_equal(@yada.eval(['var', 'true_value', 'true']), true)
    assert_equal(@yada.eval(['var', 'value', 'nil']), nil)
  end

end

