require 'test/unit'
require './lib/yada'
require './lib/environment'
require './parser/yada_parser'
require_relative 'test_util_yada'

class TestYada < TestUtil

  def setup
    @yada = Yada.new
  end

end

require_relative 'test_math_operators'
require_relative 'test_variables'
require_relative 'test_self_eval'
require_relative 'test_block'
require_relative 'test_if_expression'
require_relative 'test_while'
require_relative 'test_built_in_functions'
require_relative 'test_user_defined_functions'
require_relative 'test_lambda_functions'
require_relative 'test_context_stack'
require_relative 'test_switch_expression'
require_relative 'test_for_loop'
require_relative 'test_class'
