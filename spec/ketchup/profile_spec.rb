require 'spec/spec_helper'

describe Ketchup::Profile do
  describe '.load' do
    it "should return a new instance if valid details are provided" do
      Ketchup::API.stub!(:new => stub('api'))
      
      Ketchup::Profile.load('user@domain.com', 'secret').
        should be_a(Ketchup::Profile)
    end
    
    it "should raise an exception if invalid details are provided" do
      Ketchup::API.stub!(:new).and_raise(Ketchup::AccessDenied)
      
      lambda {
        Ketchup::Profile.load('user@domain.com', 'secret')
      }.should raise_error(Ketchup::AccessDenied)
    end
  end
  
  describe '#reload!' do
    it "should clear the stored meetings" do
      api = stub('api', :get => [])
      profile = Ketchup::Profile.new(api)
      
      profile.meetings
      profile.reload!
      
      api.should_receive(:get)
      profile.meetings
    end
  end
  
  describe '#projects' do
    it "should return an array of projects" do
      api     = stub('api', :get => [])
      profile = Ketchup::Profile.new(api)
      
      profile.projects.should be_an(Array)
    end
  end
  
  describe '#meetings' do
    it "should return a meeting array of meetings" do
      api = stub('api', :get => [])
      profile = Ketchup::Profile.new(api)
      
      profile.meetings.should be_a(Ketchup::MeetingArray)
    end
  end
end
