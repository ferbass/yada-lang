require_relative 'test_yada.rb'

class TestMath < TestYada

  def test_yada_number
    yada_assert_equal(@yada, '1', 1)
  end

  def test_yada_add
    yada_assert_equal(@yada, '(+ 2 5)', 7)
    yada_assert_equal(@yada, '(+ (+ 2 5) 5)', 12)
    yada_assert_equal(@yada, '(+ (+ 2 5) (+ 2 5))', 14)
  end

  def test_yada_sub
    yada_assert_equal(@yada, '(- 2 5)', -3)
    yada_assert_equal(@yada, '(- (- 2 5) 5)', -8)
    yada_assert_equal(@yada, '(- (- 2 5) (- 2 5))', 0)
  end

  def test_yada_add_sub
    yada_assert_equal(@yada, '(- (+ 2 5) 5)', 2)
  end

  def test_yada_multi
    yada_assert_equal(@yada, '(* 2 5)', 10)
    yada_assert_equal(@yada, '(* (* 2 5) 5)', 50)
    yada_assert_equal(@yada, '(* (* 2 5) (* 2 5))', 100)
  end

  def test_yada_div
    yada_assert_equal(@yada, '(/ 2 5)', 0)
    yada_assert_equal(@yada, '(/ (/ 2 5) 5)', 0)
  end

  def test_yada_multi_div
    yada_assert_equal(@yada, '(/ (* 2 5) 5)', 2)
  end

  def test_yada_complex_math
    yada_assert_equal(@yada, '(/ (+ (* 2 5) 5) 5)', 3)
    yada_assert_equal(@yada, '(/ (+ (* 2 5) (- 8 1)) 5)', 3)
  end

end
