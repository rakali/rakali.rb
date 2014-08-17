require 'spec_helper'

describe Rakali::Converter do
  describe "config" do
    it "should read the default config" do
      config = Rakali::Converter::DEFAULTS
      config.fetch('from').fetch('format').should eq('md')
    end

    it "should read the config via file" do
      file = fixture_path + 'docx.yml'
      subject = Rakali::Converter.new(file)
      subject.config.fetch('from').fetch('folder').should eq('minimal')
      subject.config.fetch('from').fetch('format').should eq('docx')
    end

    it "should merge default format" do
      file = fixture_path + 'only_folder_key.yml'
      subject = Rakali::Converter.new(file)
      subject.config.fetch('from').fetch('folder').should eq('minimal')
      subject.config.fetch('from').fetch('format').should eq('md')
    end

    it "should raise an error when the config file doesn't exist" do
      file = fixture_path + 'x'
      lambda { Rakali::Converter.new(file) }.should raise_error SystemExit
    end

    it "should raise an error when the config file is empty" do
      file = fixture_path + 'empty.yml'
      lambda { Rakali::Converter.new(file) }.should raise_error SystemExit
    end

    it "should raise an error when the \"from\" key config doesn't exist" do
      file = fixture_path + 'no_from_key.yml'
      lambda { Rakali::Converter.new(file) }.should raise_error SystemExit
    end
  end
end
