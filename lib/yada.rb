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
    return handle_self_evaluating(exp) if self_evaluating?(exp)
    return handle_expression(exp, env) if exp.is_a?(Array)
    return env.lookup(exp) if is_variable_name(exp)

    raise YadaError.new("Yada~Error: Invalid expression #{exp}")
  end

  def eval_global(exp)
    return eval_body(exp, @global)
  end

  private

  # Check if the expression is self-evaluating
  def self_evaluating?(exp)
    exp.is_a?(Numeric) || is_string(exp)
  end

  # Handle self-evaluating expressions
  def handle_self_evaluating(exp)
    exp.is_a?(Numeric) ? exp : exp.slice(1, exp.length - 2)
  end

  # Evaluate an expression
  def handle_expression(exp, env)
    case exp[0]
    when 'begin', 'if', 'switch',
         'default', 'while', 'for',
         'var', 'set', 'defun',
         'lambda', 'class', 'new',
          'prop'
      send("eval_#{exp[0]}", exp, env)
    else
      handle_function_call(exp, env)
    end
  end

  def eval_class(exp, env)
    _tag, name, parent, body = exp
    parent_env = eval(parent, env) || env

    class_env = Environment.new({}, parent_env)
    eval_body(body, class_env) unless body.to_a.empty?

    return env.define(name, class_env)
  end

  def eval_new(exp, env)
    _tag, class_name, *args = exp
    class_env = eval(class_name, env)
    instance_env = Environment.new({}, class_env)

    execute_user_defined_function(
      class_env.lookup('init'),
      [instance_env, *args],
    )

    return instance_env
  end

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
    _, ref, value = exp

    return define_prop(exp, env) if ref[0] == 'prop'

    return env.assign(ref, eval(value, env))
  end

  # Define Property
  # ['prop', instance, property]
  # (prop p x)
  #
  def define_prop(exp, env)
    _, ref, value = exp
    _, instance, prop = ref
    instance_env = eval(instance, env)
    return instance_env.define(prop, eval(value, env))
  end

  # Eval Property
  # ['prop', instance, property]
  # (prop p x)
  def eval_prop(exp, env)
    _, instance, prop = exp
    instance_env = eval(instance, env)
    return instance_env.lookup(prop)
  end

  # Evaluate the body of a function
  def eval_body(body, env)
    if (body[0] == 'begin')
      return eval_block(body, env)
    end
    return eval(body, env)
  end

  # Check if the expression is a number
  def is_number(exp)
    return exp.is_a? Numeric
  end

  # Check if the expression is a string
  def is_string(exp)
    return exp.is_a?(String) && exp.start_with?('"') && exp.end_with?('"')
  end

  # Check if the expression is a variable name
  def is_variable_name(exp)
    return exp.is_a?(String) && /^[+\-*\/<>=,!^a-zA-Z0-9_]+$/.match(exp)
  end

  # Evaluate a block of expressions
  def eval_block(exp, env)
    _, *exps = exp
    result = nil
    exps.each do |e|
      result = eval(e, env)
    end

    result
  end

  #
  # Function call handling
  def handle_function_call(exp, env)
    fn = eval(exp[0], env)
    args = exp[1..-1].map { |arg| eval(arg, env) }

    if fn.is_a?(Proc) || fn.is_a?(Method)
      fn.call(*args)
    else
      # User-defined function handling
      execute_user_defined_function(fn, args)
    end
  end

  #
  # User-defined function handling
  def execute_user_defined_function(fn, args)
    activation_record = fn[:args].zip(args).to_h
    activation_env = Environment.new(activation_record, fn[:env])

    new_context = ExecutionContext.new(activation_env, nil)
    @execution_stack.push(new_context)

    begin
      eval_body(fn[:body], activation_env)
    ensure
      @execution_stack.pop
    end
  end

end
