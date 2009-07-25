class NilClass
  def blank?
    true
  end
end

class String
  def blank?
    self == ""
  end
end

class Formatter
  def new
  end

  def format(parse_tree, env)
    parse_tree.elements.map do |pt|
      if pt.extension_modules.include? Parser::Statement0
        format_statement(pt, env)
      else
        pt.text_value
      end
    end.join("")
  end

  def format_statement(pt, env)
    key         = pt.field_name.text_value
    width       = pt.width.text_value
    before_text = pt.open_brackets.text_value[1..-2] # Gets rid of the brackets on either side
    end_text    = pt.close_brackets.text_value[1..-2]

    value = env[key]

    output = if value.is_a? Array
      if before_text.blank? && end_text.blank? # If there is no separator, use comma by default
        value.join(", ")
      elsif before_text.blank? || end_text.blank?
        value.join(before_text + end_text)
      else
        before_text + value.join(end_text + before_text) + end_text
      end
    else
      if value.blank?
        ""
      else
        before_text + value + end_text
      end
    end

    output = wrap_text(output, width.to_i) if !width.blank?

    output
  end

  # Borrowed from http://blog.macromates.com/2006/wrapping-text-with-regular-expressions/
  def wrap_text(txt, col = 80)
    txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "\\1\\3\n") 
  end
  
end

