require 'treetop'

$: << File.dirname(__FILE__)

require 'parser'
require 'formatter'

class Formatting
  def initialize(env, opts = {})
    @p = ParserParser.new
    @f = Formatter.new(env, opts)
  end

  def format(code)
    @f.format(@p.parse(code))
  end
end
