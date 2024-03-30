#
# Yada Interpreter
# Author: ferbass
#
# This is a simple interpreter for the Ya language.
#
#

require_relative 'environment.rb'
require_relative 'execution_context.rb'
require_relative 'transformer/transformer.rb'
require_relative 'native_functions.rb'
require_relative 'error/yada_error.rb'

class Yada

  def initialize(global = nil)
    @execution_stack = [] # Initialize the stack
    @global = global || Environment.new(NativeFunctions.functions, nil)
    @transformer = Transformer.new
  end

  def eval(exp, env = @global)

    # Self-evaluating expressions
    #

    # Numbers
    if is_number(exp)
      return exp
    end

    # Strings/Symbols
    if is_string(exp)
      return exp.slice(1, exp.length - 2)
    end

    case exp[0]
    when 'begin'   then return eval_begin(exp, env)
    when 'if'      then return eval_if(exp, env)
    when 'switch'  then return eval_switch(exp, env)
    when 'default' then return eval_default(exp, env)
    when 'while'   then return eval_while(exp, env)
    when 'for'     then return eval_for(exp, env)
    when 'var'     then return eval_var(exp, env)
    when 'set'     then return eval_set(exp, env)
    when 'defun'   then return eval_defun(exp, env)
    when 'lambda'  then return eval_lambda(exp, env)
    end

    # Variable access
    if is_variable_name(exp)
      return env.lookup(exp)
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
      activation_record = {}
      fn[:args].each_with_index do |arg, i|
        activation_record[arg] = args[i]
      end

      activation_env = Environment.new(activation_record, fn[:env])

      new_context = ExecutionContext.new(activation_env, nil) # Assuming ExecutionContext is a class you've defined
      @execution_stack.push(new_context)

      begin
        result = eval_body(fn[:body], activation_env)
      ensure
        @execution_stack.pop
      end

      return result
    end

    raise YadaError.new("Yada~Error: Invalid expression #{exp}")
  end

  private

  # block: sequence of expressions
  # ['begin', exp1, exp2, ...]
  def eval_begin(exp, env)
    block_env = Environment.new({}, env)
    return eval_block(exp, block_env)
  end

  # If expression
  # ['if', condition, true, false]
  def eval_if(exp, env)
    _, condition, true_exp, false_exp = exp
    return eval(condition, env) ? eval(true_exp, env) : eval(false_exp, env)
  end

  # Switch expression
  # ['switch', ['case1', 'block1'], ['case2', 'block2'], ['default', 'block3']]
  #
  def eval_switch(exp, env)
    if_exp = @transformer.switch_to_if(exp)
    return eval(if_exp, env)
  end

  # While expression
  # ['while', condition, body]
  # (while (< i 10) (say i))
  def eval_while(exp, env)
    _, condition, body = exp
    result = nil
    while eval(condition, env)
      result = eval(body, env)
    end
    return result
  end

  # Default expression
  # ['default', default_exp]
  # (default 10)
  #
  def eval_default(exp, env)
    _, default_exp = exp
    return eval(default_exp, env)
  end

  # Function definition
  # ['defun', 'function_name', ['arg1', 'arg2', ...], body]
  # (defun add (x y) (+ x y))
  #
  # Syntax sugar for: (var add (lambda (x y) (+ x y))
  def eval_defun(exp, env)
    _tag, name, args, body = exp

    # JIT-transpile to a variable declaration
    var_exp = @transformer.defun_to_var_lambda(exp)

    return eval(var_exp, env)
  end

  # Lambda definition
  # ['lambda', ['arg1', 'arg2', ...], body]
  # (lambda (x) (+ x 1))
  def eval_lambda(exp, env)
    _tag, args, body = exp

    return {
      args: args,
      body: body,
      env: env
    }
  end

  # For expression
  # ['for', init, condition, update, body]
  # (for (var i 0) (< i 10) (set i (+ i 1)) (say i))
  #
  # Syntax sugar for: (begin init (while condition (begin body update)))
  def eval_for(exp, env)
    while_exp = @transformer.for_to_while(exp)
    return eval(while_exp, env)
  end

  # Variables
  # Variable declaration
  # ['var', 'variable', value]
  def eval_var(exp, env)
    _, variable, value = exp
    return env.define(variable, eval(value, env))
  end

  # Set variable
  # ['set', 'variable', value]
  # ['set', 'x', 5]
  def eval_set(exp, env)
    _, variable, value = exp
    return env.assign(variable, eval(value, env))
  end

  def eval_body(body, env)
    if (body[0] == 'begin')
      return eval_block(body, env)
    end
    return eval(body, env)
  end

  def is_number(exp)
    return exp.is_a? Numeric
  end

  def is_string(exp)
    return exp.is_a?(String) && exp.start_with?('"') && exp.end_with?('"')
  end

  def is_variable_name(exp)
    return exp.is_a?(String) && /^[+\-*\/<>=,!^a-zA-Z0-9_]+$/.match(exp)
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
