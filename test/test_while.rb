class TestWhile < TestYada

  def test_while
    yada_assert_equal(@yada, '(begin
                               (var x 0)
                               (while (< x 10)
                                (begin
                                 (set x (+ x 1))
                                )
                                )
                               x
                              )', 10)
  end
end
