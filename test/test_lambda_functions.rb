require_relative 'test_yada'

class TestLambdaFunction < TestYada

    def test_lambda_function
      yada_assert_equal(@yada, '(begin
                                  (defun on_click (callback)
                                    (begin
                                     (var x 10)
                                     (var y 20)
                                     (callback (+ x y))
                                  ))
                                  (on_click (lambda (data) (* data 2)))
                                )', 60)

      # Immediately Invoked Lambda Function Expression
      yada_assert_equal(@yada, '((lambda (x) (* x x)) 2)', 4)

      # Save lambda function to a variable
      yada_assert_equal(@yada, '(begin
                                 (var square (lambda (x) (* x x)))
                                 (square 2))', 4)
    end
end
