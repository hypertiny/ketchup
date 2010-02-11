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
      pending
      api     = stub('api', :get => [])
      profile = Ketchup::Profile.new(api)
      
      profile.projects.should be_an(Array)
      profile.projects.each do |project|
        project.should be_a(Ketchup::Project)
      end
    end
  end
  
  describe '#meetings' do
    before :each do
      @api = stub('api', :get => [{
        "updated_at"    => Time.now,
        "project_id"    => nil,
        "title"         => "Another Meeting",
        "quick"         => nil,
        "public"        => false,
        "items"         => [],
        "shortcode_url" => "Bmq58b",
        "date"          => Time.now,
        "attendees"     => "",
        "description"   => nil,
        "public_url"    => "bm5aTN",
        "project_name"  => nil,
        "user_id"       => 6542,
        "location"      => nil,
        "created_at"    => Time.now
      }])
      @profile = Ketchup::Profile.new(@api)
    end
    
    it "should return an array of meetings" do
      @profile.meetings.should be_an(Array)
      @profile.meetings.each do |meeting|
        meeting.should be_a(Ketchup::Meeting)
      end
    end
  end
end
