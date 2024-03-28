##
# LR parser generated by the Syntax tool.
#
# https://www.npmjs.com/package/syntax-cli
#
#   npm install -g syntax-cli
#
#   syntax-cli --help
#
# To regenerate run:
#
#   syntax-cli \
#     --grammar ~/path-to-grammar-file \
#     --mode <parsing-mode> \
#     --output ~/ParserClassName.rb
##

class YYParse
  @@productions = [[-1,1,'_handler1'],
[0,1,'_handler2'],
[0,1,'_handler3'],
[1,1,'_handler4'],
[1,1,'_handler5'],
[1,1,'_handler6'],
[2,3,'_handler7'],
[3,2,'_handler8'],
[3,0,'_handler9']]
  @@tokens = {'NUMBER' => "4", 'STRING' => "5", 'SYMBOL' => "6", '\'(\'' => "7", '\')\'' => "8", '$' => "9"}
  @@table = [{'0' => 1, '1' => 2, '2' => 3, '4' => "s4", '5' => "s5", '6' => "s6", '7' => "s7"}, {'9' => "acc"}, {'4' => "r1", '5' => "r1", '6' => "r1", '7' => "r1", '8' => "r1", '9' => "r1"}, {'4' => "r2", '5' => "r2", '6' => "r2", '7' => "r2", '8' => "r2", '9' => "r2"}, {'4' => "r3", '5' => "r3", '6' => "r3", '7' => "r3", '8' => "r3", '9' => "r3"}, {'4' => "r4", '5' => "r4", '6' => "r4", '7' => "r4", '8' => "r4", '9' => "r4"}, {'4' => "r5", '5' => "r5", '6' => "r5", '7' => "r5", '8' => "r5", '9' => "r5"}, {'3' => 8, '4' => "r8", '5' => "r8", '6' => "r8", '7' => "r8", '8' => "r8"}, {'0' => 10, '1' => 2, '2' => 3, '4' => "s4", '5' => "s5", '6' => "s6", '7' => "s7", '8' => "s9"}, {'4' => "r6", '5' => "r6", '6' => "r6", '7' => "r6", '8' => "r6", '9' => "r6"}, {'4' => "r7", '5' => "r7", '6' => "r7", '7' => "r7", '8' => "r7"}]

  @@stack = []
  @@__ = nil
  @@__loc = nil

  @@should_capture_locations = false

  @@callbacks = {
    :on_parse_begin => nil,
    :on_parse_end => nil
  }

  EOF = '$'

  @@yytext = ''
  @@yyleng = 0

  def self.yyloc(s, e)
    # Epsilon doesn't produce location.
    if (!s || !e)
      return e if !s else s
    end

    return {
      :start_offset => s[:start_offset],
      :end_offset => e[:end_offset],
      :start_line => s[:start_line],
      :end_line => e[:end_line],
      :start_column => s[:start_column],
      :end_column => e[:end_column],
    }
  end

  def self.__=(__)
    @@__ = __
  end

  def self.__loc=(__loc)
    @@__loc = __loc
  end

  def self.__loc
    @@__loc
  end

  def self.yytext=(yytext)
    @@yytext = yytext
  end

  def self.yytext
    @@yytext
  end

  def self.yyleng=(yyleng)
    @@yyleng = yyleng
  end

  def self.yyleng
    @@yyleng
  end

  @@tokenizer = nil

def self._handler1(param_1)
YYParse.__ = param_1
end

def self._handler2(param_1)
YYParse.__ = param_1
end

def self._handler3(param_1)
YYParse.__ = param_1
end

def self._handler4(param_1)
 YYParse.__ = Integer(param_1)
end

def self._handler5(param_1)
YYParse.__ = param_1
end

def self._handler6(param_1)
YYParse.__ = param_1
end

def self._handler7(param_1,param_2,param_3)
 YYParse.__ = param_2
end

def self._handler8(param_1,param_2)
 param_1.push(param_2); YYParse.__ = param_1
end

def self._handler9()
 YYParse.__ = []
end

  def self.tokenizer=(tokenizer)
    @@tokenizer = tokenizer
  end

  def self.tokenizer
    @@tokenizer
  end

  def self.on_parse_begin(&callback)
    @@callbacks[:on_parse_begin] = callback
  end

  def self.on_parse_end(&callback)
    @@callbacks[:on_parse_end] = callback
  end

  def self.parse(string)
    if (@@callbacks[:on_parse_begin])
      @@callbacks[:on_parse_begin].call(string)
    end

    tokenizer = self.tokenizer

    if not tokenizer
      raise "Tokenizer instance wasn't specified."
    end

    tokenizer.init_string(string)

    @@stack = [0]

    token = tokenizer.get_next_token
    shifted_token = nil

    loop do
      if not token
        self.unexpected_end_of_input
      end

      state = @@stack[-1]
      column = @@tokens[token[:type]]

      if !@@table[state].has_key?(column)
        self.unexpected_token(token)
      end

      entry = @@table[state][column]

      if entry[0, 1] == 's'
        loc = nil
        if @@should_capture_locations
          loc = {
            :start_offset => token[:start_offset],
            :end_offset => token[:end_offset],
            :start_line => token[:start_line],
            :end_line => token[:end_line],
            :start_column => token[:start_column],
            :end_column => token[:end_column],
          }
        end

        @@stack.push(
          {
            :symbol => @@tokens[token[:type]],
            :semantic_value => token[:value],
            :loc => loc,
          },
          entry[1..-1].to_i
        )
        shifted_token = token
        token = tokenizer.get_next_token
      elsif entry[0, 1] == 'r'
        production_number = entry[1..-1].to_i
        production = @@productions[production_number]
        has_semantic_action = production.count > 2
        semantic_value_args = nil
        location_args = nil

        if has_semantic_action
          semantic_value_args = []

          if @@should_capture_locations
            location_args = []
          end
        end

        if production[1] != 0
          rhs_length = production[1]
          while rhs_length > 0
            rhs_length -= 1
            @@stack.pop
            stack_entry = @@stack.pop
            if has_semantic_action
              semantic_value_args.unshift(stack_entry[:semantic_value])

              if @@should_capture_locations
                location_args.unshift(stack_entry[:loc])
              end
            end
          end
        end

        reduce_stack_entry = {:symbol => production[0]}

        if has_semantic_action
          @@yytext = shifted_token ? shifted_token[:value] : nil
          @@yyleng = shifted_token ? shifted_token[:value].length : nil

          semantic_action_args = semantic_value_args

          if @@should_capture_locations
            semantic_action_args += location_args
          end

          YYParse.send(production[2], *semantic_action_args)
          reduce_stack_entry[:semantic_value] = @@__

          if @@should_capture_locations
            reduce_stack_entry[:loc] = @@__loc
          end
        end

        next_state = @@stack[-1]
        symbol_to_reduce_with = production[0].to_s

        @@stack.push(
          reduce_stack_entry,
          @@table[next_state][symbol_to_reduce_with]
        )

      elsif entry == 'acc'
        @@stack.pop
        parsed = @@stack.pop

        if @@stack.length != 1 || @@stack[0] != 0 || tokenizer.has_more_tokens
          self.unexpected_token(token)
        end

        parsed_value = parsed.has_key?(:semantic_value) ? parsed[:semantic_value] : true

        if (@@callbacks[:on_parse_end])
          @@callbacks[:on_parse_end].call(parsed_value)
        end

        return parsed_value
      end

      if not tokenizer.has_more_tokens and @@stack.length <= 1
        break
      end
    end
  end

  def self.unexpected_token(token)
    if token[:type] == self::EOF
      self.unexpected_end_of_input()
    end

    self.tokenizer.throw_unexpected_token(
      token[:value],
      token[:start_line],
      token[:start_column]
    )
  end

  def self.unexpected_end_of_input
    self.parse_error('Unexpected end of input.')
  end

  def self.parse_error(message)
    raise 'SyntaxError: ' + message
  end
end



##
# Generic tokenizer used by the parser in the Syntax tool.
#
# https://www.npmjs.com/package/syntax-cli
#
# See `--custom-tokinzer` to skip this generation, and use a custom one.
##

class SyntaxToolTokenizer__
  @@lex_rules = [[/\A\(/, '_lex_rule1'],
[/\A\)/, '_lex_rule2'],
[/\A\s+/, '_lex_rule3'],
[/\A"[^\"]*"/, '_lex_rule4'],
[/\A\d+/, '_lex_rule5'],
[/\A[\w\-+*=<>]+/, '_lex_rule6'],
[/\A\s+/, '_lex_rule7']]
  @@lex_rules_by_conditions = {'INITIAL' => [0, 1, 2, 3, 4, 5, 6]}


  @string = ''
  @cursor = 0
  @tokens_queue = []
  @states = []

  # Line-based location tracking.
  @current_line = 1
  @current_column = 0
  @current_line_begin_offset = 0

  # Location data of a matched token.
  @token_start_offset = 0
  @token_end_offset = 0
  @token_start_line = 0
  @token_end_line = 0
  @token_start_column = 0
  @token_end_column = 0

  EOF_TOKEN = {
    :type => YYParse::EOF,
    :value => ''
  }

  def _lex_rule1()
return "'('";
end

def _lex_rule2()
return "')'";
end

def _lex_rule3()
# skip whitespace
end

def _lex_rule4()
return 'STRING'
end

def _lex_rule5()
return 'NUMBER'
end

def _lex_rule6()
return 'SYMBOL'
end

def _lex_rule7()

end

  def init_string(string)
    @string = string
    @cursor = 0
    @tokens_queue = []
    @states = ['INITIAL']

    @current_line = 1
    @current_column = 0
    @current_line_begin_offset = 0

    @token_start_offset = 0
    @token_end_offset = 0
    @token_start_line = 0
    @token_end_line = 0
    @token_start_column = 0
    @token_end_column = 0
  end

  # --------------------------------------------
  # States.

  def get_current_state
    @states.last
  end

  def push_state(state)
    @states.push(state)
  end

  # Alias for `push_state`.
  def begin(state)
    push_state(state)
  end

  def pop_state
    if @states.length > 1
      return @states.pop
    end

    @states[0]
  end

  def get_next_token
    if @tokens_queue.length > 0
      return _to_token(@tokens_queue.shift())
    end

    if not has_more_tokens
      return SyntaxToolTokenizer__::EOF_TOKEN
    end

    string = @string[@cursor..-1]

    lex_rules_for_state = @@lex_rules_by_conditions[get_current_state]

    lex_rules_for_state.each { |lex_rule_index|
      lex_rule = @@lex_rules[lex_rule_index]

      matched = match(string, lex_rule[0])

      # Manual handling of EOF token (the end of string). Return it
      # as `EOF` symbol.
      if string == '' and matched == ''
        @cursor += 1
      end

      if matched != nil
        YYParse.yytext = matched
        YYParse.yyleng = matched.length
        token = self.send(lex_rule[1])

        if not token
          return get_next_token
        end

        if token.kind_of?(Array)
          tokens_to_queue = token[1..-1]
          token = token[0]
          if tokens_to_queue.length > 0
            @tokens_queue.concat(tokens_to_queue)
          end
        end

        return _to_token(token, matched)
      end
    }

    if is_eof
      @cursor += 1
      return SyntaxToolTokenizer__::EOF_TOKEN
    end

    throw_unexpected_token(string[0], @current_line, @current_column)
  end

  ##
  # Throws default "Unexpected token" exception, showing the actual
  # line from the source, pointing with the ^ marker to the bad token.
  # In addition, shows `line:column` location.
  #
  def throw_unexpected_token(symbol, line, column)
    line_source = @string.split('\n')[line - 1]

    pad = ' ' * column;
    line_data = "\n\n" + line_source + "\n" + pad + "^\n"

    raise (
      line_data + 'Unexpected token: "' + symbol.to_s + '" at ' +
      line.to_s + ':' + column.to_s + '.'
    )
  end

  def _capture_location(matched)
    # Absolute offsets.
    @token_start_offset = @cursor

    # Line-based locations, start.
    @token_start_line = @current_line
    @token_start_column = @token_start_offset - @current_line_begin_offset

    # Extract `\n` in the matched token.
    matched.enum_for(:scan, /\n/).each {
      Regexp.last_match.begin(0)
      @current_line += 1
      @current_line_begin_offset = @token_start_offset + Regexp.last_match.begin(0) + 1
    }

    @token_end_offset = @cursor + matched.length

    # Line-based locations, end.
    @token_end_line = @current_line
    @token_end_column = @current_column = (@token_end_offset - @current_line_begin_offset)
  end

  def _to_token(token_type, yytext='')
    return {
      :type => token_type,
      :value => yytext,
      :start_offset => @token_start_offset,
      :end_offset => @token_end_offset,
      :start_line => @token_start_line,
      :end_line => @token_end_line,
      :start_column => @token_start_column,
      :end_column => @token_end_column,
    }
  end

  def is_eof
    return @cursor == @string.length
  end

  def has_more_tokens
    return @cursor <= @string.length
  end

  def match(string, regexp)
    matches = regexp.match(string)
    if matches != nil
      _capture_location(matches[0])
      @cursor += matches[0].length
      return matches[0]
    end
    return nil
  end
end

YYParse::tokenizer = SyntaxToolTokenizer__.new


class YadaParser < YYParse; end
