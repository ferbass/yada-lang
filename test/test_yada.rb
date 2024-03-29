require 'test/unit'
require './lib/yada.rb'
require './lib/environment.rb'
require './parser/yada_parser.rb'
require './test/test_util_yada.rb'

class TestYada < TestUtil

  def setup
    @yada = Yada.new
  end

end

require './test/test_math.rb'
require './test/test_variables.rb'
require './test/test_self_eval.rb'
require './test/test_block.rb'
require './test/test_if_expression.rb'
require './test/test_while.rb'
require './test/test_built_in_functions.rb'
require_relative 'test_user_defined_functions'
