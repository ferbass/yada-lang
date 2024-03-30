class TestMath < TestYada

  def test_yada_number
    yada_assert_equal(@yada, '1', 1)
  end

  def test_yada_add
    yada_assert_equal(@yada, '(+ 2 5)', 7)
    yada_assert_equal(@yada, '(+ (+ 2 5) 5)', 12)
    yada_assert_equal(@yada, '(+ (+ 2 5) (+ 2 5))', 14)

    yada_assert_equal(@yada, '(- 2 5)', -3)
    yada_assert_equal(@yada, '(- (- 2 5) 5)', -8)
    yada_assert_equal(@yada, '(- (- 2 5) (- 2 5))', 0)

    yada_assert_equal(@yada, '(- (+ 2 5) 5)', 2)

    yada_assert_equal(@yada, '(* 2 5)', 10)
    yada_assert_equal(@yada, '(* (* 2 5) 5)', 50)
    yada_assert_equal(@yada, '(* (* 2 5) (* 2 5))', 100)

    yada_assert_equal(@yada, '(/ 2 5)', 0)
    yada_assert_equal(@yada, '(/ (/ 2 5) 5)', 0)

    yada_assert_equal(@yada, '(/ (* 2 5) 5)', 2)

    yada_assert_equal(@yada, '(/ (+ (* 2 5) 5) 5)', 3)
    yada_assert_equal(@yada, '(/ (+ (* 2 5) (- 8 1)) 5)', 3)

    yada_assert_equal(@yada, '(begin (var x 1) (++ x))', 2)
    yada_assert_equal(@yada, '(begin (var x 1) (-- x))', 0)
    yada_assert_equal(@yada, '(begin (var x 1) (+= x 2))', 3)
    yada_assert_equal(@yada, '(begin (var x 1) (-= x 2))', -1)
    yada_assert_equal(@yada, '(begin (var x 1) (*= x 2))', 2)
    yada_assert_equal(@yada, '(begin (var x 1) (/= x 2))', 0)

    yada_assert_equal(@yada, '(begin (var x 2) (^ x 3))', 8)
  end

end
