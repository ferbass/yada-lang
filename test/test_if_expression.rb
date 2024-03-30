require_relative 'test_yada'

class TestIfExpression < TestYada

  def test_if_expression
    yada_assert_equal(@yada, '(if true 1 2)', 1) # true
    yada_assert_equal(@yada, '(if false 1 2)', 2) # false
    yada_assert_equal(@yada, '(begin
                               (var x 5)
                               (var y 10)
                               (if (> x y)
                                20
                                10
                               )
                              )', 10)
  end

end
