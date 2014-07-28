require 'spec_helper'

describe Rakali::Document do
  describe "validate" do
    it "should not validate when there is no input" do
      options = {}
      subject = Rakali::Document.new(options)
      subject.valid?.should be false
      subject.errors.length.should == 1
      subject.errors.first.should match("No input found.")
    end

    it "should not validate when the input file doesn't exist" do
      options = {file: 'file' }
      subject = Rakali::Document.new(options)
      subject.valid?.should be false
      subject.errors.length.should == 1
      subject.errors.first.should match("No input found.")
    end

    it "should validate with minimal input via file" do
      options = { file: fixture_path + 'minimal.md' }
      subject = Rakali::Document.new(options)
      subject.valid?.should be true
      subject.errors.should be_empty
    end

    it "should not validate with minimal input and extended schema" do
      options = { file: fixture_path + 'minimal.md', schema: schemata_path + 'jekyll.json' }
      subject = Rakali::Document.new(options)
      subject.valid?.should be false
      subject.errors.length.should == 2
      subject.errors.first.should match("The property '#/0/unMeta' did not contain a required property of 'title'")
      subject.errors.last.should match("The property '#/0/unMeta' did not contain a required property of 'layout'")
    end

    it "should validate with extended input and extended schema" do
      options = { file: fixture_path + 'jekyll.md', schema: schemata_path + 'jekyll.json' }
      subject = Rakali::Document.new(options)
      subject.valid?.should be true
      subject.errors.should be_empty
    end
  end
end
