class TestExecutionContextStack < TestYada

  def test_nested_function_calls_with_shadowing_and_recursion
    yada_assert_equal(@yada, '(defun outer (n)
                                (var x 10)
                                (defun inner (m)
                                 (if (== m 0)
                                  x
                                  (begin
                                   (var x (+ m 20))
                                   (inner (- m 1)))))
                                (inner n))
                               (outer 3)', 10)
  end
end
