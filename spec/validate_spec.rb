require 'spec_helper'

describe Rakali::Validate do

  describe "validate" do
    # let(:output) { capture(:stdout) { subject.validate } }

    # context "with valid commands" do
    #   valid_test_data.each do |data|
    #     let(:expected_output) { data[:output] }
    #     let(:commands) { StringIO.new(data[:input]).map { |a| a.strip } }

    #     it "should process the commands and output the results" do
    #       subject.stub(:gets).and_return(*commands, "EXIT")
    #       output.should include(expected_output)
    #     end
    #   end
    # end

    it "should raise an error without STDIN" do
      expect { subject.validate }.to raise_error(Thor::Error, 'Error: no input via STDIN or FILE')
    end
  end
end
