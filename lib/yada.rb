#
# Yada Interpreter
# Author: ferbass
#
# This is a simple interpreter for the Ya language.
#
#

require './lib/environment.rb'

class Yada

  def initialize(global = nil)
    variables = {
      'nil' => nil,
      'false' => false,
      'true' => true,
      'VERSION' => '0.0.1'
    }
    @global = global || Environment.new
  end

  def eval(exp, env = @global)

    # Self-evaluating expressions

    # Numbers
    if is_number(exp)
      return exp
    end

    if exp[0] == '+'
      return eval(exp[1], env) + eval(exp[2], env)
    end

    if exp[0] == '-'
      return eval(exp[1], env) - eval(exp[2], env)
    end

    if exp[0] == '*'
      return eval(exp[1], env) * eval(exp[2], env)
    end

    if exp[0] == '/'
      return eval(exp[1], env) / eval(exp[2], env)
    end

    # Strings
    # ["Hello"] => "Hello"

    if is_string(exp)
      return exp.slice(1, exp.length - 2)
    end

    # If expression
    # ['if', condition, true, false]

    if exp[0] == 'if'
      _, condition, true_exp, false_exp = exp
      return eval(condition, env) ? eval(true_exp, env) : eval(false_exp, env)
    end

    # While expression
    # ['while', condition, body]

    if exp[0] == 'while'
      _, condition, body = exp

      result = nil
      while eval(condition, env)
        result = eval(body, env)
      end
      return result
    end


    # Comparisson operators
    # '>', '<', '>=', '<=', '==', '!=', 'and', 'or'
    # ['>', 2, 1] => true
    #

    if exp[0] == '>'
      return eval(exp[1], env) > eval(exp[2], env)
    end

    if exp[0] == '<'
      return eval(exp[1], env) < eval(exp[2], env)
    end

    if exp[0] == '>='
      return eval(exp[1], env) >= eval(exp[2], env)
    end

    if exp[0] == '<='
      return eval(exp[1], env) <= eval(exp[2], env)
    end

    if exp[0] == '=='
      return eval(exp[1], env) == eval(exp[2], env)
    end

    if exp[0] == '!='
      return eval(exp[1], env) != eval(exp[2], env)
    end

    if exp[0] == 'and'
      return eval(exp[1], env) && eval(exp[2], env)
    end

    if exp[0] == 'or'
      return eval(exp[1], env) || eval(exp[2], env)
    end


    # Variables

    # Variable declaration
    if exp[0] == 'var'
      _, variable, value = exp
      return env.define(variable, eval(value, env))
    end

    # Variable access
    if is_variable_name(exp)
      return env.lookup(exp)
    end

    # Set variable
    # ['set', 'variable', value]
    # ['set', 'x', 5]
    if exp[0] == 'set'
      _, variable, value = exp
      return env.assign(variable, eval(value, env))
    end

    # block: sequence of expressions
    if exp[0] == 'begin'
      block_env = Environment.new({}, env)
      return eval_block(exp, block_env)
    end

    raise StandardError.new("Yada~StandardError: Invalid expression #{exp}")
  end

  def is_number(exp)
    return exp.is_a? Numeric
  end

  def is_string(exp)
    return exp.is_a?(String) && exp.start_with?('"') && exp.end_with?('"')
  end

  def is_variable_name(exp)
    return exp.is_a?(String) && /^[a-zA-Z_][a-zA-Z0-9_]*$/.match(exp)
  end

  def eval_block(exp, env)
    _, *exps = exp
    result = nil
    exps.each do |e|
      result = eval(e, env)
    end

    result
  end

end
