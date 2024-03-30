#
# Author: ferbass
# This is a simple AST transformer for the Yada language.
#
# The transformer is responsible for transforming the AST into a form that is easier to interpret.
#
class Transformer

  # Transform a variable definition to a lambda
  def defun_to_var_lambda(exp)
    _tag, name, args, body = exp
    return ['var', name, ['lambda', args, body]]
  end

  # Transform a switch statement to an if statement
  # (switch
  #  (cond1 block1)
  #  (cond2 block2)
  #  (default block3))
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

  # Transform a for loop to a while loop
  # (for (var i 0) (< i 10) (set i (+ i 1)) (say i))
  def for_to_while(exp)
    _tag, init, condition, update, body = exp

    return ['begin',
            init,
            ['while', condition,
             ['begin',
              body,
              update]]]
  end

end
