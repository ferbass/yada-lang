require 'test/unit'
require './lib/yada.rb'
require './lib/environment.rb'

class TestYada < Test::Unit::TestCase

  def setup
    env = Environment.new({
      'nil' => nil,
      'false' => false,
      'true' => true,
      'VERSION' => '0.0.1'
    })
    @yada = Yada.new(env)
  end

end

require './test/test_math.rb'
require './test/test_variables.rb'
require './test/test_self_eval.rb'
require './test/test_block.rb'
require './test/test_if_expression.rb'
require './test/test_while.rb'
require './test/test_util.rb'

