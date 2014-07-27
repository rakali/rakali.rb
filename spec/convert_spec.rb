require 'spec_helper'

describe Rakali::Convert do

  describe "convert" do
    it "should raise an error without STDIN" do
      expect { subject.convert }.to raise_error(Thor::Error, 'Error: no input via STDIN or FILE')
    end
  end
end
