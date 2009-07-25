require 'spec/spec_helper'

describe Formatter do
  before do
    @f = Formatter.new
    @env = {"name" => "Justin", "names" => %w{Justin Jans Jim Scott}, "long" => "this is some long text this is some long text"}
    @empty_env = {"empty_names" => []}
  end

  def p(text)
    ParserParser.new.parse(text)
  end

  it "should replace a simple value" do
    @f.format(p("[[name]]"), @env).should == "Justin"
  end

  it "should work with pre-text" do
    @f.format(p("[My name is [name]]"), @env).should == "My name is Justin"
  end

  it "should work with post-text" do
    @f.format(p("[[name] was my name]"), @env).should == "Justin was my name"
  end

  it "should work with pre- and post-text" do
    @f.format(p("[Hello, [name] is my name]"), @env).should == "Hello, Justin is my name"
  end

  it "should display nothing if the value is blank" do
    @f.format(p("[Hello, [name] is my name]"), @empty_env).should == ""
    @f.format(p("[[empty_names]]"), @empty_env).should == ""
  end

  it "should use commas to join by default" do
    @f.format(p("[[names]]"), @env).should == "Justin, Jans, Jim, Scott"
  end

  it "should use the pre- or post-text to join if only one is specified" do
    @f.format(p("[\n[names]]"), @env).should == "Justin\nJans\nJim\nScott"
    @f.format(p("[[names]\n]"), @env).should == "Justin\nJans\nJim\nScott"
  end

  it "should use the pre- and post-text to wrap ever element if both are specified" do
    @f.format(p("[<li>[names]</li>]"), @env).should == "<li>Justin</li><li>Jans</li><li>Jim</li><li>Scott</li>"
  end

  it "should allow anything around the brackets" do
    @f.format(p("<ul>[<li>[names]</li>]</ul>"), @env).should == "<ul><li>Justin</li><li>Jans</li><li>Jim</li><li>Scott</li></ul>"
  end

  it "should allow multiple statements" do
    @f.format(p("[[name]] is in <ul>[<li>[names]</li>]</ul>"), @env).should == "Justin is in <ul><li>Justin</li><li>Jans</li><li>Jim</li><li>Scott</li></ul>"
  end

  it "should allow wrapping" do
    @f.format(p("[[long 10]]"), @env).should == "this is\nsome long\ntext this\nis some\nlong text\n"
  end
end

