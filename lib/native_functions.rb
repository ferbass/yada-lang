#
# Author : ferbass
# This is a simple built-in functions for the Yada language.
#
module NativeFunctions
  def self.functions
    {
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
  end
end
