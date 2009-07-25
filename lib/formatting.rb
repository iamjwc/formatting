require 'rubygems'
require 'treetop'

require 'lib/parser'
require 'lib/formatter'

class Formatting
  def new(code)
    @p = ParserParser.new.parse(code)
    @f = Formatter.new
  end

  def format(env)
    @f.format(@p, env)
  end
end
