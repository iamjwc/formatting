require 'spec/spec_helper'

describe Formatter do
  def p(text)
    ParserParser.new.parse(text)
  end

  describe "without namespaces" do
    before do
      @env = {"name" => "Justin", "names" => %w{Justin Jans Jim Scott}, "long" => "this is some long text this is some long text"}
      @empty_env = {"empty_names" => []}
      @f = Formatter.new(@env)
      @f_empty = Formatter.new(@empty_env)
    end
  
    it "should replace a simple value" do
      @f.format(p("[[name]]")).should == "Justin"
    end
  
    it "should work with pre-text" do
      @f.format(p("[My name is [name]]")).should == "My name is Justin"
    end
  
    it "should work with post-text" do
      @f.format(p("[[name] was my name]")).should == "Justin was my name"
    end
  
    it "should work with pre- and post-text" do
      @f.format(p("[Hello, [name] is my name]")).should == "Hello, Justin is my name"
    end
  
    it "should display nothing if the value is blank" do
      @f_empty.format(p("[Hello, [name] is my name]")).should == ""
      @f_empty.format(p("[[empty_names]]")).should == ""
    end
  
    it "should use commas to join by default" do
      @f.format(p("[[names]]")).should == "Justin, Jans, Jim, Scott"
    end
  
    it "should use the pre- or post-text to join if only one is specified" do
      @f.format(p("[\n[names]]")).should == "Justin\nJans\nJim\nScott"
      @f.format(p("[[names]\n]")).should == "Justin\nJans\nJim\nScott"
    end
  
    it "should use the pre- and post-text to wrap ever element if both are specified" do
      @f.format(p("[<li>[names]</li>]")).should == "<li>Justin</li><li>Jans</li><li>Jim</li><li>Scott</li>"
    end
  
    it "should allow anything around the brackets" do
      @f.format(p("<ul>[<li>[names]</li>]</ul>")).should == "<ul><li>Justin</li><li>Jans</li><li>Jim</li><li>Scott</li></ul>"
    end
  
    it "should allow multiple statements" do
      @f.format(p("[[name]] is in <ul>[<li>[names]</li>]</ul>")).should == "Justin is in <ul><li>Justin</li><li>Jans</li><li>Jim</li><li>Scott</li></ul>"
    end
  
    it "should allow wrapping" do
      @f.format(p("[[long 10]]")).should == "this is\nsome long\ntext this\nis some\nlong text\n"
    end
  end

  describe "with namespaces" do
    before do
      @env = {
        "people" => {"name" => "Justin Camerer", "other" => {"object" => "blender", "name" => "Timothy Hayner"}},
        "other"  => {"object" => "toaster", "coffee" => "mug"}
      }
      @f = Formatter.new(@env, :default_namespace => "people")
    end

    it "should look in the default namespace first" do
      @f.format(p("[[other:object]]")).should == "blender"
    end

    it "should look in the global namespace first if key is prefixed with :" do
      @f.format(p("[[:other:object]]")).should == "toaster"
    end

    it "should look in the global namespace if the value isnt found in the default namespace" do
      @f.format(p("[[other:coffee]]")).should == "mug"
      @f.format(p("[[people:name]]")).should == "Justin Camerer"
    end

    it "should convert \\n into a newline char" do
      @f.format(p('\n')).should == "\n"
      @f.format(p('my name is\njustin')).should == "my name is\njustin"
    end
  end

  describe Formatting do
    it "should be short hand for the Formatter object" do
      f = Formatting.new("hey" => "pal")
      f.format("[[hey]]").should == "pal"
    end
  end
end

