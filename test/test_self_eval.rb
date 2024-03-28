require './test/test_yada.rb'

class TestEval < Test::Unit::TestCase

  def setup
    @yada = Yada.new
  end

 # String
  def test_yada_string
    assert_equal(@yada.eval('"a"'), 'a')
  end

end
