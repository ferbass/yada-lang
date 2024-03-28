require './test/test_yada.rb'

class TestVariables < TestYada

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

    #test set variable
    assert_equal(@yada.eval(['var', 'y', 5]), 5)
    assert_equal(@yada.eval(['set', 'y', 10]), 10)
  end


end
