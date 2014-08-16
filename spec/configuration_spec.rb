require 'spec_helper'

describe Rakali::Configuration do
  describe "config" do
    it "should read the default config" do
      config = Rakali::Configuration::DEFAULTS
      config['from']['format'].should eq('md')
    end

    it "should read the config via file" do
      file = fixture_path + 'minimal.yml'
      config = subject.read_config_file(file)
      config['from']['folder'].should eq('minimal')
      config['from']['format'].should eq('docx')
    end
  end
end
