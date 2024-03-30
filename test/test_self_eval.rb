class TestEval < TestYada

 # String
  def test_yada_string
    assert_equal(@yada.eval('"a"'), 'a')
  end

end
