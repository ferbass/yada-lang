require_relative 'test_yada'

class TestBuiltInFunctions < TestYada

  def test_built_in_functions

    # Math
    yada_assert_equal(@yada, '(+ 1 2)', 3)
    yada_assert_equal(@yada, '(- 1 2)', -1)
    yada_assert_equal(@yada, '(* 2 3)', 6)
    yada_assert_equal(@yada, '(/ 6 3)', 2)

    # Comparison
    yada_assert_equal(@yada, '(> 1 2)', false)
    yada_assert_equal(@yada, '(>= 2 1)', true)
    yada_assert_equal(@yada, '(> 2 1)', true)
    yada_assert_equal(@yada, '(< 1 2)', true)
    yada_assert_equal(@yada, '(<= 2 1)', false)
    yada_assert_equal(@yada, '(< 2 1)', false)
    yada_assert_equal(@yada, '(== 1 1)', true)
    yada_assert_equal(@yada, '(== 1 2)', false)
    yada_assert_equal(@yada, '(!= 1 1)', false)
    yada_assert_equal(@yada, '(!= 1 2)', true)
    yada_assert_equal(@yada, '(not 2 1)', true)
    yada_assert_equal(@yada, '(not 1 1)', false)
    yada_assert_equal(@yada, '(and true true)', true)
    yada_assert_equal(@yada, '(and true false)', false)
  end

end
