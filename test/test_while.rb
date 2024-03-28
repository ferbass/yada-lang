require './test/test_yada.rb'

class TestWhile < Test::Unit::TestCase

  def setup
    @yada = Yada.new
  end

  def test_while
    assert_equal(@yada.eval(
      ['begin',
       ['var', 'x', 0],
       ['while', ['<', 'x', 10],
        ['begin',
         ['set', 'x', ['+', 'x', 1]]
        ]
       ],
       'x'
      ]),
      10)
  end
end
