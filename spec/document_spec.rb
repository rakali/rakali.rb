require 'spec_helper'

describe Rakali::Document do
  describe "convert" do
    it "should convert minimal input" do
      document = fixture_path + 'minimal.md'
      config = Rakali::Utils.deep_merge_hashes(Rakali::Converter::DEFAULTS,
        { 'from' => { 'folder' => fixture_path }, 'to' => { 'format' => 'docx' } })
      subject = Rakali::Document.new(document, config)
      subject.valid?.should be_truthy
      subject.errors.should be_empty
    end
  end

  describe "validate" do
    it "should validate with empty input" do
      document = fixture_path + 'empty.md'
      config = Rakali::Utils.deep_merge_hashes(Rakali::Converter::DEFAULTS,
        { 'from' => { 'folder' => fixture_path } })
      subject = Rakali::Document.new(document, config)
      subject.valid?.should be_truthy
      subject.errors.should be_empty
    end

    it "should not validate with empty input and extended schema" do
      document = fixture_path + 'empty.md'
      config = Rakali::Utils.deep_merge_hashes(Rakali::Converter::DEFAULTS,
        { 'from' => { 'folder' => fixture_path }, 'schema' => 'schemata/jekyll.json' })
      subject = Rakali::Document.new(document, config)
      subject.valid?.should be_falsey
      subject.errors.length.should == 2
      subject.errors.first.should match("The property '#/0/unMeta' did not contain a required property of 'title'")
      subject.errors.last.should match("The property '#/0/unMeta' did not contain a required property of 'layout'")
    end

    it "should not validate with empty input and extended schema and raise error" do
      document = fixture_path + 'empty.md'
      config = Rakali::Utils.deep_merge_hashes(Rakali::Converter::DEFAULTS,
        { 'from' => { 'folder' => fixture_path }, 'schema' => 'schemata/jekyll.json', 'strict' => true })
      lambda { Rakali::Document.new(document, config) }.should raise_error SystemExit
    end

    it "should validate with extended input and extended schema" do
      document = fixture_path + 'jekyll.md'
      config = Rakali::Utils.deep_merge_hashes(Rakali::Converter::DEFAULTS,
        { 'from' => { 'folder' => fixture_path }, 'schema' => 'schemata/jekyll.json' })
      subject = Rakali::Document.new(document, config)
      subject.valid?.should be_truthy
      subject.errors.should be_empty
    end
  end
end
