require_relative 'test_yada.rb'

class TestVariables < TestYada

 # Variables
  def test_yada_variable
    #variable declaration
    yada_assert_equal(@yada, '(var x 5)', 5)
    #variable access
    yada_assert_equal(@yada, 'x', 5)
    assert_equal(@yada.eval('x'), 5)

    assert_raises(NameError) do
      @yada.eval('y')
    end

    #test prebaked variables
    yada_assert_equal(@yada, 'VERSION', '0.0.1')
    yada_assert_equal(@yada, '(var true_value true)', true)
    yada_assert_equal(@yada, '(var value nil)', nil)

    #test set variable
    yada_assert_equal(@yada, '(var y 10)', 10)
    yada_assert_equal(@yada, '(set y 50)', 50)
  end
end
