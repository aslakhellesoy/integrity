require File.dirname(__FILE__) + "/spec_helper"

describe Integrity::Build do
  include DatabaseSpecHelper

  def valid_attributes
    {
      :commit_identifier => "0367ee0566843edcf871a86f0eb23d90c4ee1d14",
      :commit_metadata   => {
        :author  => "Simon Rozet <simon@rozet.name>",
        :message => "started build model",
        :date => "2008-07-21 08:43:05 -0300"
      },
      :output => "foo",
      :successful => true
    }
  end

  before(:each) do
    @build = Integrity::Build.new
  end

  it "should not be valid" do
    @build.should_not be_valid
  end

  it "needs an output, a status, a commit_identifier and a commit_metadata" do
    @build.attributes = valid_attributes
    @build.should be_valid
  end

  it "should have output" do
    @build.output = "foo"
    @build.output.should == "foo"
  end

  it "should have a 'pending' status by default" do
    @build.should be_pending
  end

  it "should have an author" do
    @build.commit_metadata = { :author => "Simon Rozet <simon@rozet.name>" }
    @build.commit_author.name.should == "Simon Rozet"
    @build.commit_author.email.should == "simon@rozet.name"
    @build.commit_author.full.should == @build.commit_metadata[:author]
  end

  it "should have a commit message" do
    @build.commit_metadata = { :message => "The greatest commit ever" }
    @build.commit_message.should == @build.commit_metadata[:message]
  end

  it "should have a commit date" do
    @build.commit_metadata = { :date => Time.now }
    @build.commited_at.should == @build.commit_metadata[:date]
  end

  it "should have a commit identifier" do
    @build.commit_identifier = "0367ee0566843edcf871a86f0eb23d90c4ee1d14"
    @build.commit_identifier.should == "0367ee0566843edcf871a86f0eb23d90c4ee1d14"
  end

  it "output should default to ''" do
    @build.output.should == ""
  end

  it "#human_readable_status should return 'Build successful' or 'Build Failed' or 'Waiting...', depending on the status" do
    @build.status = "successful"
    @build.human_readable_status.should == "Build Successful"
    @build.status = "failed"
    @build.human_readable_status.should == "Build Failed"
    @build.status = "pending"
    @build.human_readable_status.should == "Waiting..."
  end

  it "should be successful, failed or pending depending on the status" do
    @build.status = "successful"
    @build.should be_successful
    @build.status = "failed"
    @build.should be_failed
    @build.status = "pending"
    @build.should be_pending
  end

  it "should return the short version of the commit identifier" do
    @build.stub!(:commit_identifier).and_return("0367ee0566843edcf871a86f0eb23d90c4ee1d14")
    @build.short_commit_identifier.should == "0367ee0"
  end

  it "should return the full commit identifier as the short version if it has less than 6 characters" do
    @build.stub!(:commit_identifier).and_return("234")
    @build.short_commit_identifier.should == "234"
  end
end
