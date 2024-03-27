require './test/test_yada.rb'

class TestVariables < Test::Unit::TestCase

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
