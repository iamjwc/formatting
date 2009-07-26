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
  def initialize(env, opts = {})
    @env = env
    @default_namespace = opts[:default_namespace].to_s
  end

  def format(parse_tree)
    parse_tree.elements.map do |pt|
      if pt.extension_modules.include? Parser::Statement0
        format_statement(pt)
      else
        pt.text_value
      end
    end.join("")
  end

  def format_statement(pt)
    key         = pt.field_name.text_value
    width       = pt.width.text_value
    before_text = pt.open_brackets.text_value[1..-2] # Gets rid of the brackets on either side
    end_text    = pt.close_brackets.text_value[1..-2]

    value = self.value_for(key)

    output = if value.is_a? Array
      if before_text.blank? && end_text.blank? # If there is no separator, use comma by default
        value.join(", ")
      elsif before_text.blank? || end_text.blank?
        value.join(before_text.to_s + end_text.to_s)
      else
        before_text + value.join(end_text.to_s + before_text.to_s) + end_text
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

  #First check if the value exists as the key with the default namespace
  # if not, then remove the default namespace and check there.
  # If key starts with ':', then don't check with the default namespace
  def value_for(key)
    check_default_namespace = key[0..0] != ":"
    keys = key.split(":")
    if check_default_namespace
      fetch_value(@default_namespace.split(":") + keys, @env) || fetch_value(keys, @env)
    else
      keys = keys[1..-1] # Trash first empty element
      fetch_value(keys, @env)
    end
  end

  def fetch_value(keys, values)
    if keys.empty?
      values unless values.is_a? Hash
    elsif values && values[keys.first]
      fetch_value(keys[1..-1], values[keys.first])
    end
  end

  # Borrowed from http://blog.macromates.com/2006/wrapping-text-with-regular-expressions/
  def wrap_text(txt, col = 80)
    txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "\\1\\3\n") 
  end
  
end

