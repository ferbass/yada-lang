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

    # nested environment
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
  end
end
