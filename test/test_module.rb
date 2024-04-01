class TestModule < TestYada

  def test_module_declaration

    yada_assert_equal(@yada, '(module Math
                               (begin
                                  (var MAX_VALUE 10000)
                                  (var MIN_VALUE -10000)
                                  (var PI 3,141592653589793)

                                  (defun abs (value)
                                    (if (< value 0)
                                      (- value)
                                      value))
                                  (defun sqrt (value)
                                    (* value value))
                               ))
    ((prop Math abs) -10)', 10)
  end

end
