class TestForLoop < TestYada

    def test_for_loop
      yada_assert_equal(@yada, '(var x 0)
                                (for (var i 0)
                                 (< i 10)
                                 (set i (+ i 1))
                                 (begin
                                  (set x (+ x 1))
                                 )
                                )
                                x', 10)
    end

end

