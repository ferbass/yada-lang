#
# Author: ferbass
# This is a simple AST transformer for the Yada language.
#
class Transformer

  # Transform a variable definition to a lambda
  def defun_to_var_lambda(exp)
    _tag, name, args, body = exp
    return ['var', name, ['lambda', args, body]]
  end

  def switch_to_if(exp)
    _tag, *cases = exp

    if_exp = ['if', nil, nil, nil]
    current = if_exp
    cases.each_with_index do |(cond, block), i|
      current[1] = cond
      current[2] = block

      if i < cases.length - 1 && cases[i + 1].first != 'default'
        current[3] = ['if']
        current = current[3]
      else
        default_case = cases.find { |c| c.first == 'default' }
        current[3] = default_case ? default_case[1] : nil
        break
      end
    end

    return if_exp
  end
end
