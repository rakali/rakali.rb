require 'spec_helper'

describe Rakali::Document do
  describe "validate" do
    it "should not validate when there is no input" do
      options = {}
      subject = Rakali::Document.new(options)
      subject.valid?.should be false
      subject.errors.length.should == 2
      subject.errors.first.should match("The property '#/0' of type NilClass did not match the following type: object")
      subject.errors.last.should match("The property '#/1' of type NilClass did not match the following type: array")
    end

    it "should validate with minimal input via file" do
      options = { file: fixture_path + 'minimal.json' }
      subject = Rakali::Document.new(options)
      subject.valid?.should be true
      subject.errors.should be_empty
    end

    it "should not validate with minimal input and extended schema" do
      options = { file: fixture_path + 'minimal.json', schema: schemata_path + 'jekyll.json' }
      subject = Rakali::Document.new(options)
      subject.valid?.should be false
      subject.errors.length.should == 2
      subject.errors.first.should match("The property '#/0/unMeta' did not contain a required property of 'title'")
      subject.errors.last.should match("The property '#/0/unMeta' did not contain a required property of 'layout'")
    end

    it "should validate with extended input and extended schema" do
      options = { file: fixture_path + 'jekyll.json', schema: schemata_path + 'jekyll.json' }
      subject = Rakali::Document.new(options)
      subject.valid?.should be true
      subject.errors.should be_empty
    end
  end
end
