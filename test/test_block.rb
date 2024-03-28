require './test/test_yada.rb'

class TestBlock < TestYada

  def setup
    @yada = Yada.new
  end

  # Block
  def test_yada_block
    assert_equal(@yada.eval(
      ['begin',
       ['var', 'x', 5],
       'x'
      ]),
      5)
    assert_equal(@yada.eval(
      ['begin',
       ['var', 'x', 5],
       ['var', 'y', 10],
       ['+', 'x', 'y']
      ]),
      15)

    # block nested environment
    assert_equal(@yada.eval(
      ['begin',
       ['var', 'x', 5],
       ['begin',
        ['var', 'x', 10],
        'x'
       ],
       'x'
      ]),
      5)

    assert_equal(@yada.eval(
      ['begin',
       ['var', 'x', 5],
       ['var', 'result', ['begin',
        ['var', 'y', ['+', 'x', 5]],
        'y'
       ]],
       'result'
      ]),
      10)

    assert_equal(@yada.eval(
      ['begin',
       ['var', 'x', 5],
       ['var', 'result', ['begin',
        ['set', 'x', 10]],
        'x'
       ],
       'result'
      ]),
      10
    )
  end

  def test_with_ast_syntax
    yada_assert_equal(@yada,'(begin (var x 1) (* x 10))', 10)
    yada_assert_equal(@yada,
                      '(begin
                       (var x 10)
                       (var y 20)
                       (+ (* x 10) y))',
                      120)
  end
end
