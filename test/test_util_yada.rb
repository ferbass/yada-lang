require 'test/unit'

class TestUtil < Test::Unit::TestCase

  def yada_assert_equal(yada, code, expected)
    exp = YadaParser.parse(code)
    assert_equal(yada.eval(exp), expected)
  end

end
