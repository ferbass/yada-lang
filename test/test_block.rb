require './test/test_yada.rb'

class TestBlock < Test::Unit::TestCase

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
end
