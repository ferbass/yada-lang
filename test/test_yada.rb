require 'test/unit'
require './lib/yada.rb'
require './lib/environment.rb'
require './parser/yada_parser.rb'
require_relative 'test_util_yada.rb'

class TestYada < TestUtil

  def setup
    @yada = Yada.new
  end

end

require_relative 'test_math.rb'
require_relative 'test_variables.rb'
require_relative 'test_self_eval.rb'
require_relative 'test_block.rb'
require_relative 'test_if_expression.rb'
require_relative 'test_while.rb'
require_relative 'test_built_in_functions.rb'
require_relative 'test_user_defined_functions.rb'
require_relative 'test_lambda_functions.rb'
