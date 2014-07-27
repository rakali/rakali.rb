require 'spec_helper'

describe Rakali::Filter do

  describe "filter" do
    it "should raise an error without STDIN" do
      expect { subject.filter }.to raise_error(Thor::Error, 'Error: no input via STDIN or FILE')
    end
  end
end
