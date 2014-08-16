require 'spec_helper'

describe Rakali::Logger do
  let(:topic) { "Topic:" }
  let(:message) { "This is the message." }
  let(:output) { "             #{topic} #{message}" }

  describe "debug" do
    subject { Rakali::Logger.new(Rakali::Logger::DEBUG) }

    it "initialize" do
      subject.log_level.should == 0
    end

    it "debug" do
      capture_stdout { subject.debug topic, message }.should start_with(output)
    end

    it "info" do
      capture_stdout { subject.info topic, message }.should start_with(output)
    end

    it "warn" do
      capture_stderr { subject.warn topic, message }.should start_with(output.yellow)
    end

    it "error" do
      capture_stderr { subject.error topic, message }.should start_with(output.red)
    end
  end

  describe "info" do
    it "initialize" do
      subject.log_level.should == 1
    end

    it "debug" do
      capture_stdout { subject.debug topic, message }.should eq("")
    end

    it "info" do
      capture_stdout { subject.info topic, message }.should start_with(output)
    end

    it "warn" do
      capture_stderr { subject.warn topic, message }.should start_with(output.yellow)
    end

    it "error" do
      capture_stderr { subject.error topic, message }.should start_with(output.red)
    end
  end

  describe "warn" do
    subject { Rakali::Logger.new(Rakali::Logger::WARN) }

    it "initialize" do
      subject.log_level.should == 2
    end

    it "debug" do
      capture_stdout { subject.debug topic, message }.should eq("")
    end

    it "info" do
      capture_stdout { subject.info topic, message }.should eq("")
    end

    it "warn" do
      capture_stderr { subject.warn topic, message }.should start_with(output.yellow)
    end

    it "error" do
      capture_stderr { subject.error topic, message }.should start_with(output.red)
    end
  end

  describe "error" do
    subject { Rakali::Logger.new(Rakali::Logger::ERROR) }

    it "initialize" do
      subject.log_level.should == 3
    end

    it "debug" do
      capture_stdout { subject.debug topic, message }.should eq("")
    end

    it "info" do
      capture_stdout { subject.info topic, message }.should eq("")
    end

    it "warn" do
      capture_stderr { subject.warn topic, message }.should eq("")
    end

    it "error" do
      capture_stderr { subject.error topic, message }.should start_with(output.red)
    end
  end
end
