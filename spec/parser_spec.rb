require 'spec/spec_helper'

describe ParserParser do
  before do
    @p = ParserParser.new
  end

  after do
    puts @p.failure_reason if @p.failure_reason
  end

  def parsed_as_entire_statement?(text)
    @p.parse(text).elements[0].text_value == text
  end

  it "should be able to parse [[name]]" do
    parsed_as_entire_statement?("[[name]]").should be_true
  end

  it "should be able to parse simple statement with extra spaces inside" do
    parsed_as_entire_statement?("[[ name ]]").should be_true
    parsed_as_entire_statement?("[[name  ]]").should be_true
    parsed_as_entire_statement?("[[  name]]").should be_true
  end

  it "should be able to parse simple statement with padding" do
    parsed_as_entire_statement?("[[name 80]]").should be_true
    parsed_as_entire_statement?("[[name 4]]").should be_true
  end

  it "should not be able to parse simple statement with negative padding" do
    parsed_as_entire_statement?("[[name -80]]").should be_false
    parsed_as_entire_statement?("[[name -4]]").should be_false
  end

  it "should be able to parse a statement with pre-text" do
    parsed_as_entire_statement?("[My name is [name]]").should be_true
  end

  it "should be able to parse a statement with post-text" do
    parsed_as_entire_statement?("[[name] was my name]").should be_true
  end

  it "should be able to parse a statement with pre- and post-text" do
    parsed_as_entire_statement?("[Hi! My name is [name]. Nice to meet you]").should be_true
  end

  it "should be able to parse a statement with an escaped bracket in the pre-text" do
    parsed_as_entire_statement?('[\[[name]]').should be_true
  end

  it "should be able to parse a statement with many escaped brackets in the pre-text" do
    parsed_as_entire_statement?('[\[\[\[\[[name]]').should be_true
  end

  it "should be able to parse a statement with an escaped bracket in the post-text" do
    parsed_as_entire_statement?('[[name]\]]').should be_true
  end

  it "should be able to parse a statement with many escaped brackets in the post-text" do
    parsed_as_entire_statement?('[[name]\]\]\]\]\]]').should be_true
  end

  it "should be able to parse multiple statements" do
    @p.parse("[[name]][[name]]").elements.size.should == 2
  end

  it "should be able to parse multiple statements with noise around them" do
    @p.parse("this is noise [[name]] as is [[name]] this").elements.size.should == 5
  end

  it "should not parse escaped brackets as a statement" do
    @p.parse('\[[blah]]').elements.size.should == 3 # 3 because "\[" is 1, "[" is 1, and the rest is 1
  end
end

