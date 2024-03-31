class TestClass < TestYada

  def test_class_without_body
    yada_assert_not_nil(@yada, '(class MyClass nil)')
  end

  def test_class_definition
    yada_assert_equal(@yada, '(class Point nil
      (begin

        (defun init (self x y)
          (begin
            (set (prop self x) x)
            (set (prop self y) y)))

        (defun calc (self)
          (+ (prop self x) (prop self y)))))

    (var p (new Point 10 20))

    ((prop p calc) p)', 30)
  end

end
