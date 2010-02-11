require 'spec/spec_helper'

describe Ketchup::Meeting do
  before :each do
    @api = stub('api')
  end
  
  describe '#initialize' do
    it "should initialize all the attributes" do
      time = Time.now
      meeting = Ketchup::Meeting.new(@api,
        "updated_at"    => time,
        "project_id"    => nil,
        "title"         => "Another Meeting",
        "quick"         => nil,
        "public"        => false,
        "items"         => [],
        "shortcode_url" => "Bmq58b",
        "date"          => time,
        "attendees"     => "Me, You, Them",
        "description"   => "Just a meeting",
        "public_url"    => "bm5aTN",
        "project_name"  => "Top Secret",
        "user_id"       => 6542,
        "location"      => "Somewhere",
        "created_at"    => time
      )
      
      meeting.updated_at.should == time
      meeting.project_id.should be_nil
      meeting.title.should == 'Another Meeting'
      meeting.quick.should be_nil
      meeting.public.should be_false
      meeting.items.should == []
      meeting.shortcode_url.should == 'Bmq58b'
      meeting.date.should == time
      meeting.attendees.should == 'Me, You, Them'
      meeting.description.should == 'Just a meeting'
      meeting.public_url.should == 'bm5aTN'
      meeting.project_name.should == 'Top Secret'
      meeting.user_id.should == 6542
      meeting.location.should == 'Somewhere'
      meeting.created_at.should == time
    end
  end
  
  describe '#new_record?' do
    it "should return true if meeting has no shortcode_url" do
      meeting = Ketchup::Meeting.new @api
      meeting.should be_new_record
    end
    
    it "should return false if meeting has a shortcode_url" do
      meeting = Ketchup::Meeting.new @api, 'shortcode_url' => 'foo'
      meeting.should_not be_new_record
    end
  end
  
  describe '#save' do
    it "should send a post if creating" do
      @api.should_receive(:post).and_return({})
      
      meeting = Ketchup::Meeting.new @api, 'title' => 'foo'
      meeting.save
    end
    
    it "should include writeable attributes in the post" do
      @api.should_receive(:post) do |query, options|
        options['title'].should == 'foo'
        {}
      end
      
      meeting = Ketchup::Meeting.new @api, 'title' => 'foo'
      meeting.save
    end
    
    it "should not include read-only attributes in the post" do
      @api.should_receive(:post) do |query, options|
        options.keys.should_not include('created_at')
        {}
      end
      
      meeting = Ketchup::Meeting.new @api, 'created_at' => Time.now
      meeting.save
    end
    
    it "should update the object with the response" do
      @api.stub!(:post => {'shortcode_url' => 'foo'})
      
      meeting = Ketchup::Meeting.new @api, 'title' => 'Foo'
      meeting.save
      meeting.shortcode_url.should == 'foo'
    end
    
    it "should send a put if updating" do
      @api.should_receive(:put).and_return({})
      
      meeting = Ketchup::Meeting.new @api, 'shortcode_url' => 'foo'
      meeting.save
    end
    
    it "should include writeable attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options['title'].should == 'foo'
        {}
      end
      
      meeting = Ketchup::Meeting.new @api,
        'shortcode_url' => 'foo', 'title' => 'foo'
      meeting.save
    end
    
    it "should not include read-only attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options.keys.should_not include('created_at')
        {}
      end
      
      meeting = Ketchup::Meeting.new @api,
        'shortcode_url' => 'foo', 'created_at' => Time.now
      meeting.save
    end
  end
  
  describe '#destroy' do
    it "should delete the meeting" do
      @api.should_receive(:delete) do |query, options|
        query.should == '/meetings/foo.json'
      end
      
      meeting = Ketchup::Meeting.new @api, 'shortcode_url' => 'foo'
      meeting.destroy
    end
    
    it "should do nothing if the record isn't already saved" do
      @api.should_not_receive(:delete)
      
      meeting = Ketchup::Meeting.new @api
      meeting.destroy
    end
  end
end
