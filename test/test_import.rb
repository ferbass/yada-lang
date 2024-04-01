class TestImport < TestYada

  def test_import_expression

    yada_assert_equal(@yada, '(import Math)
                                ((prop Math abs) -10)', 10)

    yada_assert_equal(@yada, '(import Math)
                                ((prop Math sqrt) 10)', 100)

  end

end
