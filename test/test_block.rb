class TestBlock < TestYada

  # Block
  def test_yada_block
    yada_assert_equal(@yada, '(begin (var x 5) x)', 5)
    yada_assert_equal(@yada, '(begin (var x 5) (var y 10) (+ x y))', 15)

    # block nested environment
    yada_assert_equal(@yada, '(begin (var x 5) (begin (var x 10) x) x)', 5)

    yada_assert_equal(@yada, '(begin (var x 5) (var result (begin (var y (+ x 5)) y)) result)', 10)

    yada_assert_equal(@yada, '(begin (var x 5) (var result (begin (set x 10)) x) result)', 10)
  end
end
