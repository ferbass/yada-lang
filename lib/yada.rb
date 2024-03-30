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
      '++' => ->(a) { a + 1 },
      '--' => ->(a) { a - 1 },
      '+=' => ->(a, b) { a += b },
      '-=' => ->(a, b) { a -= b },
      '*=' => ->(a, b) { a *= b },
      '/=' => ->(a, b) { a /= b },
      '^' => ->(a, b) { a ** b },
      # Comparison
      '>' => ->(a, b) { a > b },
      '<' => ->(a, b) { a < b },
      '>=' => ->(a, b) { a >= b },
      '<=' => ->(a, b) { a <= b },
      '==' => ->(a, b) { a == b },
      '!='  => ->(a, b) { a != b },
      'not' => ->(a, b = nil) { b ? a != b : !a},
      'and' => ->(a, b) { a && b },
      'or'  => ->(a, b) { a || b },

      # Print
      # (say "Hello" "World!")
      # => "Hello World!"
      # TODO: Implement a better way to print
      'say' => ->(*a) {
        output = a.join( ' ')
        puts output
        return output
      }
    }
    @execution_stack = [] # Initialize the stack
    @global = global || Environment.new(global_env)
    @transformer = Transformer.new
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

    if exp[0] == 'default'
      _, default_exp = exp
      return eval(default_exp, env)
    end

    # Switch expression
    # ['switch', ['case1', 'block1'], ['case2', 'block2'], ['default', 'block3']]
    #
    if exp[0] == 'switch'
      if_exp = @transformer.switch_to_if(exp)
      return eval(if_exp, env)
    end

    # While expression
    # ['while', condition, body]
    # (while (< i 10) (say i))

    if exp[0] == 'while'
      _, condition, body = exp

      result = nil
      while eval(condition, env)
        result = eval(body, env)
      end
      return result
    end

    # For expression
    # ['for', init, condition, update, body]
    # (for (var i 0) (< i 10) (set i (+ i 1)) (say i))
    #
    # Syntax sugar for: (begin init (while condition (begin body update)))
    if exp[0] == 'for'
      while_exp = @transformer.for_to_while(exp)
      return eval(while_exp, env)
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

    # Function definition
    # ['defun', 'function_name', ['arg1', 'arg2', ...], body]
    # (defun add (x y) (+ x y))
    #
    # Syntax sugar for: (var add (lambda (x y) (+ x y))
    if exp[0] == 'defun'
      _tag, name, args, body = exp

      # JIT-transpile to a variable declaration
      var_exp = @transformer.defun_to_var_lambda(exp)

      return eval(var_exp, env)
    end

    # Lambda definition
    # ['lambda', ['arg1', 'arg2', ...], body]
    # (lambda (x) (+ x 1))

    if exp[0] == 'lambda'
      _tag, args, body = exp

      return {
        args: args,
        body: body,
        env: env
      }
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

    raise StandardError.new("Yada~StandardError: Invalid expression #{exp}")
  end

  private

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
