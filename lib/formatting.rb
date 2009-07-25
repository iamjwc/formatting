require 'treetop'

$: << File.dirname(__FILE__)

require 'parser'
require 'formatter'

class Formatting
  def initialize(code)
    @p = ParserParser.new.parse(code)
    @f = Formatter.new
  end

  def format(env)
    @f.format(@p, env)
  end
end
