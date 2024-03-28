require './test/test_yada.rb'

class TestIfExpression < TestYada

  def test_if_expression
    assert_equal(@yada.eval(
      ['begin',
       ['var', 'x', 5],
       ['var', 'y', 10],
       ['if', ['>', 'x', 'y'],
        ['set', 'x', 20],
        ['set', 'x', 10]
       ],
       'x'
      ]),
      10)
  end

end
