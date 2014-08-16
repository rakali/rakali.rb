require 'spec_helper'

describe Rakali::Document do
  describe "validate" do
    it "should not validate when the input file doesn't exist" do
      file = fixture_path + 'x'
      subject = Rakali::Document.new(file)
      subject.valid?.should be_falsey
      subject.errors.length.should == 1
      subject.errors.first.should start_with("No such file or directory")
    end

    it "should validate with minimal input via file" do
      file = fixture_path + 'minimal.md'
      subject = Rakali::Document.new(file)
      subject.valid?.should be_truthy
      subject.errors.should be_empty
    end

    it "should not validate with minimal input and extended schema" do
      file = fixture_path + 'minimal.md'
      options = { schema: schemata_path + 'jekyll.json' }
      subject = Rakali::Document.new(file, options)
      subject.valid?.should be_falsey
      subject.errors.length.should == 2
      subject.errors.first.should match("The property '#/0/unMeta' did not contain a required property of 'title'")
      subject.errors.last.should match("The property '#/0/unMeta' did not contain a required property of 'layout'")
    end

    it "should validate with extended input and extended schema" do
      file = fixture_path + 'jekyll.md'
      options = { schema: schemata_path + 'jekyll.json' }
      subject = Rakali::Document.new(file, options)
      puts subject.output
      subject.valid?.should be_truthy
      subject.errors.should be_empty
    end
  end
end
