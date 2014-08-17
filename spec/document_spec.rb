require 'spec_helper'

describe Rakali::Document do
  describe "validate" do
    it "should validate with minimal input" do
      document = fixture_path + 'minimal.md'
      config = { "schema" => "schemata/default.json" }
      subject = Rakali::Document.new(document, config)
      subject.valid?.should be_truthy
      subject.errors.should be_empty
    end

    it "should not validate with minimal input and extended schema" do
      document = fixture_path + 'minimal.md'
      config = { "schema" => "schemata/jekyll.json" }
      subject = Rakali::Document.new(document, config)
      subject.valid?.should be_falsey
      subject.errors.length.should == 2
      subject.errors.first.should match("The property '#/0/unMeta' did not contain a required property of 'title'")
      subject.errors.last.should match("The property '#/0/unMeta' did not contain a required property of 'layout'")
    end

    it "should not validate with minimal input and extended schema and raise error" do
      document = fixture_path + 'minimal.md'
      config = { "schema" => "schemata/jekyll.json", 'strict' => true }
      lambda { Rakali::Document.new(document, config) }.should raise_error SystemExit
    end

    it "should validate with extended input and extended schema" do
      document = fixture_path + 'jekyll.md'
      config = { "schema" => "schemata/jekyll.json" }
      subject = Rakali::Document.new(document, config)
      subject.valid?.should be_truthy
      subject.errors.should be_empty
    end
  end
end
