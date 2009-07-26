require 'treetop'

$: << File.dirname(__FILE__)

require 'parser'
require 'formatter'

class Formatting
  def initialize(env)
    @p = ParserParser.new
    @f = Formatter.new(env)
  end

  def format(code)
    @f.format(@p.parse(code))
  end
end
