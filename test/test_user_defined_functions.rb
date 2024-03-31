class TestUserDefinedFunctions < TestYada

  def test_user_defined_functions
    yada_assert_equal(@yada, '(defun square (x)
                                (* x x))
                               (square 5)', 25)

    # Comlexy body
    # The body of a function can be a sequence of expressions.
    yada_assert_equal(@yada, '(begin
                               (defun calc (x y)
                                (begin
                                 (var z 10)
                                 (+ (* x y) z)
                                ))
                               (calc 5 10))', 60)

    # Clojures
    # A closure is a function that captures the environment in which it was created.
    yada_assert_equal(@yada, '(var value 100)
                               (defun calc (x y)
                                (begin
                                 (var z (+ x y))
                                 (defun inner (foo)
                                  (+ (+ z foo) value))
                                 inner
                                ))
                               (var fn (calc 20 10))
                               (fn 30)', 160)

    # Recursive Functions
    # A function can call itself.
    #
    yada_assert_equal(@yada, '(defun factorial (x)
                                (if (<= x 1)
                                 1
                                 (* x (factorial (- x 1)))))
                               (factorial 5)', 120)
  end

end
