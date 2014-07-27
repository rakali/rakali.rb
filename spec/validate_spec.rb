require 'spec_helper'

describe Rakali::Validate do

  describe "validate" do
    it "should raise an error without STDIN" do
      expect { subject.validate }.to raise_error(Thor::Error, 'Error: no input via STDIN or FILE')
    end
  end
end
