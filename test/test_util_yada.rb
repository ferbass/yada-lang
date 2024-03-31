require 'test/unit'
require 'stringio'

class TestUtil < Test::Unit::TestCase

  module TestUtil
  class AssertionMessage < StandardError; end
  end

  def yada_assert_equal(yada, code, expected)
    exp = YadaParser.parse("(begin #{code})")
    assert_equal(yada.eval_global(exp), expected)
  end

  def yada_assert_not_equal(yada, code, expected)
    exp = YadaParser.parse(code)
    assert_not_equal(yada.eval(exp), expected)
  end

  def yada_assert_raises(yada, code, expected)
    exp = YadaParser.parse(code)

    error = nil
    begin
      capture_stdout { yada.eval(exp) }
    rescue => e
      error = e
    end

    unless error && error.message.include?(expected)
      raise TestUtil::AssertionMessage, "Expected to raise an error containing '#{expected}', but got '#{error&.message}'"
    end
  end

  private

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end

end
