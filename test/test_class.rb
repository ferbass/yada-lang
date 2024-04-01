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

    # This test should run in the same context as the previous one
    yada_assert_equal(@yada, '(class Point3D Point
        (begin

          (defun init (self x y z)
            (begin
              ((prop (super Point3D) init) self x y)
              (set (prop self z) z)))

          (defun calc (self)
            (+ ((prop (super Point3D) calc) self)
               (prop self z)))))

      (var p (new Point3D 10 20 30))
      ((prop p calc) p)', 60)
  end

end
