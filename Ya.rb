#
# Ya Interpreter
# Author: ferbass
#
# This is a simple interpreter for the Ya language.
#

class Ya
  def eval(exp)

    if is_number(exp)
      return exp
    end

    if exp[0] == '+'
      return eval(exp[1]) + eval(exp[2])
    end

    if exp[0] == '-'
      return eval(exp[1]) - eval(exp[2])
    end

    if exp[0] == '*'
      return eval(exp[1]) * eval(exp[2])
    end

    if exp[0] == '/'
      return eval(exp[1]) / eval(exp[2])
    end

    if is_string(exp)
      return exp.slice(1, exp.length - 2)
    end

    throw 'YaError: Invalid expression'
  end

  def is_number(exp)
    return exp.is_a? Numeric
  end

  def is_string(exp)
    return exp.is_a?(String) && exp.start_with?('"') && exp.end_with?('"')
  end

end
