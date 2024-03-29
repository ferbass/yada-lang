require_relative 'test_yada'

class TestUserDefinedFunctions < TestYada

  def test_user_defined_functions
    yada_assert_equal(@yada, '(begin
                               (defun square (x)
                                (* x x))
                               (square 5))', 25)

    yada_assert_equal(@yada, '(begin
                               (defun calc (x y)
                                (begin
                                 (var z 10)
                                 (+ (* x y) z)
                                ))
                               (calc 5 10))', 60)

    yada_assert_equal(@yada, '(begin
                               (var value 100)
                               (defun calc (x y)
                                (begin
                                 (var z (+ x y))
                                 (defun inner (foo)
                                  (+ (+ z foo) value))
                                 inner
                                ))
                               (var fn (calc 20 10))
                               (fn 30))', 160)
  end

end
