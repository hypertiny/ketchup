require 'spec/spec_helper'

describe Ketchup::MeetingArray do
  before :each do
    @api = stub('api', :get => [])
  end
  
  it "should be a subclass of Array" do
    Ketchup::MeetingArray.superclass.should == Array
  end
  
  describe '#initialize' do
    it "should load meetings from the api" do
      @api.stub!(:get => [{
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
      meetings = Ketchup::MeetingArray.new @api
      meetings.first.should be_a(Ketchup::Meeting)
    end
  end
  
  describe '#build' do
    before :each do
      @meetings = Ketchup::MeetingArray.new @api
    end
    
    it "should set the meeting's API object" do
      meeting = @meetings.build 'title' => 'foo'
      meeting.api.should == @api
    end
    
    it "should pass on the options to the new meeting" do
      meeting = @meetings.build 'title' => 'foo'
      meeting.title.should == 'foo'
    end
    
    it "should add the meeting to the array" do
      meeting = @meetings.build 'title' => 'foo'
      @meetings.should include(meeting)
    end
  end
  
  describe '#create' do
    before :each do
      @api.stub!(:get => [], :post => {'title' => 'foo'})
      @meetings = Ketchup::MeetingArray.new @api
    end
    
    it "should set the meeting's API object" do
      meeting = @meetings.create 'title' => 'foo'
      meeting.api.should == @api
    end
    
    it "should pass on the options to the new meeting" do
      meeting = @meetings.create 'title' => 'foo'
      meeting.title.should == 'foo'
    end
    
    it "should add the meeting to the array" do
      meeting = @meetings.create 'title' => 'foo'
      @meetings.should include(meeting)
    end
    
    it "should have already saved the meeting" do
      @api.should_receive(:post)
      
      meeting = @meetings.create 'title' => 'foo'
    end
  end
end
