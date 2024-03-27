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

    throw 'YaError: Invalid expression'
  end

  def is_number(ext)
    return ext.is_a? Numeric
  end
end
