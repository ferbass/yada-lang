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
    global_env = {
      'nil' => nil,
      'false' => false,
      'true' => true,
      'VERSION' => '0.0.1',
      # Built-in functions
      # Math
      '+' => ->(a, b) { a + b },
      '-' => ->(a, b = nil) { b ? a - b : -a },
      '*' => ->(a, b) { a * b },
      '/' => ->(a, b) { a / b },
      # Comparison
      '>' => ->(a, b) { a > b },
      '<' => ->(a, b) { a < b },
      '>=' => ->(a, b) { a >= b },
      '<=' => ->(a, b) { a <= b },
      '==' => ->(a, b) { a == b },
      '!=' => ->(a, b) { a != b },
      'and' => ->(a, b) { a && b },
      'or' => ->(a, b) { a || b }
    }
    @global = global || Environment.new(global_env)
  end

  def eval(exp, env = @global)

    # Self-evaluating expressions

    # Numbers
    if is_number(exp)
      return exp
    end

    # Strings/Symbols
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

    # Function calls
    # (function_name arg1 arg2 ...)
    #
    if exp.is_a?(Array)
      fn = eval(exp[0], env)
      args = exp[1..-1].map { |arg| eval(arg, env) }

      # 1. Native function:
      if fn.is_a?(Proc) || fn.is_a?(Method)
        return fn.call(*args)
      end

      # 2. User-defined function:
      #return _call_user_defined_function(fn, args)
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
    return exp.is_a?(String) && /^[+\-*\/<>=,!a-zA-Z0-9_]+$/.match(exp)
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
