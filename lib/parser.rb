module Parser
  include Treetop::Runtime

  def root
    @root || :statements
  end

  def _nt_statements
    start_index = index
    if node_cache[:statements].has_key?(index)
      cached = node_cache[:statements][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1 = index
      r2 = _nt_non_open_bracket
      if r2
        r1 = r2
      else
        r3 = _nt_statement
        if r3
          r1 = r3
        else
          if index < input_length
            r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r4 = nil
          end
          if r4
            r1 = r4
          else
            @index = i1
            r1 = nil
          end
        end
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

    node_cache[:statements][start_index] = r0

    r0
  end

  module Statement0
    def open_brackets
      elements[0]
    end

    def space
      elements[1]
    end

    def field_name
      elements[2]
    end

    def space
      elements[3]
    end

    def width
      elements[4]
    end

    def space
      elements[5]
    end

    def close_brackets
      elements[6]
    end
  end

  def _nt_statement
    start_index = index
    if node_cache[:statement].has_key?(index)
      cached = node_cache[:statement][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_open_brackets
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        r3 = _nt_field_name
        s0 << r3
        if r3
          r4 = _nt_space
          s0 << r4
          if r4
            r5 = _nt_width
            s0 << r5
            if r5
              r6 = _nt_space
              s0 << r6
              if r6
                r7 = _nt_close_brackets
                s0 << r7
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Statement0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:statement][start_index] = r0

    r0
  end

  def _nt_width
    start_index = index
    if node_cache[:width].has_key?(index)
      cached = node_cache[:width][index]
      @index = cached.interval.end if cached
      return cached
    end

    r1 = _nt_number
    if r1
      r0 = r1
    else
      r0 = instantiate_node(SyntaxNode,input, index...index)
    end

    node_cache[:width][start_index] = r0

    r0
  end

  module Number0
  end

  def _nt_number
    start_index = index
    if node_cache[:number].has_key?(index)
      cached = node_cache[:number][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('\G[1-9]', true, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[0-9]', true, index)
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Number0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:number][start_index] = r0

    r0
  end

  module FieldName0
  end

  def _nt_field_name
    start_index = index
    if node_cache[:field_name].has_key?(index)
      cached = node_cache[:field_name][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if has_terminal?('\G[_a-zA-Z]', true, index)
      r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?('\G[\\w]', true, index)
          r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(FieldName0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:field_name][start_index] = r0

    r0
  end

  module OpenBrackets0
    def open_bracket
      elements[0]
    end

    def open_bracket
      elements[2]
    end
  end

  def _nt_open_brackets
    start_index = index
    if node_cache[:open_brackets].has_key?(index)
      cached = node_cache[:open_brackets][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_open_bracket
    s0 << r1
    if r1
      r3 = _nt_beginning_text
      if r3
        r2 = r3
      else
        r2 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r2
      if r2
        r4 = _nt_open_bracket
        s0 << r4
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(OpenBrackets0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:open_brackets][start_index] = r0

    r0
  end

  module CloseBrackets0
    def close_bracket
      elements[0]
    end

    def close_bracket
      elements[2]
    end
  end

  def _nt_close_brackets
    start_index = index
    if node_cache[:close_brackets].has_key?(index)
      cached = node_cache[:close_brackets][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_close_bracket
    s0 << r1
    if r1
      r3 = _nt_ending_text
      if r3
        r2 = r3
      else
        r2 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r2
      if r2
        r4 = _nt_close_bracket
        s0 << r4
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(CloseBrackets0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:close_brackets][start_index] = r0

    r0
  end

  def _nt_beginning_text
    start_index = index
    if node_cache[:beginning_text].has_key?(index)
      cached = node_cache[:beginning_text][index]
      @index = cached.interval.end if cached
      return cached
    end

    r0 = _nt_non_open_bracket

    node_cache[:beginning_text][start_index] = r0

    r0
  end

  def _nt_ending_text
    start_index = index
    if node_cache[:ending_text].has_key?(index)
      cached = node_cache[:ending_text][index]
      @index = cached.interval.end if cached
      return cached
    end

    r0 = _nt_non_close_bracket

    node_cache[:ending_text][start_index] = r0

    r0
  end

  def _nt_open_bracket
    start_index = index
    if node_cache[:open_bracket].has_key?(index)
      cached = node_cache[:open_bracket][index]
      @index = cached.interval.end if cached
      return cached
    end

    if has_terminal?("[", false, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("[")
      r0 = nil
    end

    node_cache[:open_bracket][start_index] = r0

    r0
  end

  def _nt_close_bracket
    start_index = index
    if node_cache[:close_bracket].has_key?(index)
      cached = node_cache[:close_bracket][index]
      @index = cached.interval.end if cached
      return cached
    end

    if has_terminal?("]", false, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure("]")
      r0 = nil
    end

    node_cache[:close_bracket][start_index] = r0

    r0
  end

  def _nt_escaped_open_bracket
    start_index = index
    if node_cache[:escaped_open_bracket].has_key?(index)
      cached = node_cache[:escaped_open_bracket][index]
      @index = cached.interval.end if cached
      return cached
    end

    if has_terminal?('\[', false, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('\[')
      r0 = nil
    end

    node_cache[:escaped_open_bracket][start_index] = r0

    r0
  end

  def _nt_escaped_close_bracket
    start_index = index
    if node_cache[:escaped_close_bracket].has_key?(index)
      cached = node_cache[:escaped_close_bracket][index]
      @index = cached.interval.end if cached
      return cached
    end

    if has_terminal?('\]', false, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 2))
      @index += 2
    else
      terminal_parse_failure('\]')
      r0 = nil
    end

    node_cache[:escaped_close_bracket][start_index] = r0

    r0
  end

  module NonOpenBracket0
  end

  def _nt_non_open_bracket
    start_index = index
    if node_cache[:non_open_bracket].has_key?(index)
      cached = node_cache[:non_open_bracket][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1 = index
      r2 = _nt_escaped_open_bracket
      if r2
        r1 = r2
      else
        i3, s3 = index, []
        i4 = index
        if has_terminal?('[', false, index)
          r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('[')
          r5 = nil
        end
        if r5
          r4 = nil
        else
          @index = i4
          r4 = instantiate_node(SyntaxNode,input, index...index)
        end
        s3 << r4
        if r4
          if index < input_length
            r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r6 = nil
          end
          s3 << r6
        end
        if s3.last
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          r3.extend(NonOpenBracket0)
        else
          @index = i3
          r3 = nil
        end
        if r3
          r1 = r3
        else
          @index = i1
          r1 = nil
        end
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:non_open_bracket][start_index] = r0

    r0
  end

  module NonCloseBracket0
  end

  def _nt_non_close_bracket
    start_index = index
    if node_cache[:non_close_bracket].has_key?(index)
      cached = node_cache[:non_close_bracket][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1 = index
      r2 = _nt_escaped_close_bracket
      if r2
        r1 = r2
      else
        i3, s3 = index, []
        i4 = index
        if has_terminal?(']', false, index)
          r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(']')
          r5 = nil
        end
        if r5
          r4 = nil
        else
          @index = i4
          r4 = instantiate_node(SyntaxNode,input, index...index)
        end
        s3 << r4
        if r4
          if index < input_length
            r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("any character")
            r6 = nil
          end
          s3 << r6
        end
        if s3.last
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          r3.extend(NonCloseBracket0)
        else
          @index = i3
          r3 = nil
        end
        if r3
          r1 = r3
        else
          @index = i1
          r1 = nil
        end
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:non_close_bracket][start_index] = r0

    r0
  end

  def _nt_space
    start_index = index
    if node_cache[:space].has_key?(index)
      cached = node_cache[:space][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?('\G[ \\n]', true, index)
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

    node_cache[:space][start_index] = r0

    r0
  end

end

class ParserParser < Treetop::Runtime::CompiledParser
  include Parser
end


