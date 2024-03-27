#
# Yada Interpreter
# Author: ferbass
#
# This is a simple interpreter for the Ya language.
#
#

require './environment'

class Yada

  def initialize(global = nil)
    @global = global || Environment.new
  end

  def eval(exp, env = @global)

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

    if is_string(exp)
      return exp.slice(1, exp.length - 2)
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

    raise StandardError.new('Yada~StandardError: Invalid expression')
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

end
