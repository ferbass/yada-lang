require_relative 'test_yada'

class TestSwitchExpression < TestYada

  def test_switch_expression
    yada_assert_equal(@yada, '(begin
                               (var x 10)
                               (switch ((== x 10) 100)
                                       ((> x 10) 200)
                                       (default 300)))', 100)
  end

end
