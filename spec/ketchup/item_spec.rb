require 'spec/spec_helper'

describe Ketchup::Item do
  before :each do
    @api     = stub('api')
    @meeting = Ketchup::Meeting.new @api
  end
  
  describe '#initialize' do
    it "should initialize all the attributes" do
      time    = Time.now
      item    = Ketchup::Item.new(@api, @meeting,
        'updated_at' => time,
        'shortcode_url' => 'ZCTYXAeDb_rQ3IkRq9nutcwfxUpNPLBOsHM28Ela',
        'notes'         => [],
        'content'       => 'Foo',
        'position'      => 1,
        'meeting_id'    => 4321,
        'created_at'    => time
      )
      
      item.updated_at.should == time
      item.shortcode_url.should == 'ZCTYXAeDb_rQ3IkRq9nutcwfxUpNPLBOsHM28Ela'
      item.notes.should == []
      item.content.should == 'Foo'
      item.position.should == 1
      item.meeting_id.should == 4321
      item.created_at.should == time
    end
  end
  
  describe '#new_record?' do
    it "should return true if meeting has no shortcode_url" do
      item = Ketchup::Item.new @api, @meeting
      item.should be_new_record
    end
    
    it "should return false if meeting has a shortcode_url" do
      item = Ketchup::Item.new @api, @meeting, 'shortcode_url' => 'foo'
      item.should_not be_new_record
    end
  end
  
  describe '#save' do
    it "should send a post if creating" do
      @api.should_receive(:post).and_return({})
      
      item = Ketchup::Item.new @api, @meeting, 'content' => 'foo'
      item.save
    end
    
    it "should include writeable attributes in the post" do
      @api.should_receive(:post) do |query, options|
        options['content'].should == 'foo'
        {}
      end
      
      item = Ketchup::Item.new @api, @meeting, 'content' => 'foo'
      item.save
    end
    
    it "should not include read-only attributes in the post" do
      @api.should_receive(:post) do |query, options|
        options.keys.should_not include('created_at')
        {}
      end
      
      item = Ketchup::Item.new @api, @meeting, 'created_at' => Time.now
      item.save
    end
    
    it "should update the object with the response" do
      @api.stub!(:post => {'shortcode_url' => 'foo'})
      
      item = Ketchup::Item.new @api, @meeting, 'title' => 'Foo'
      item.save
      item.shortcode_url.should == 'foo'
    end
    
    it "should send a put if updating" do
      @api.should_receive(:put).and_return({})
      
      item = Ketchup::Item.new @api, @meeting, 'shortcode_url' => 'foo'
      item.save
    end
    
    it "should include writeable attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options['content'].should == 'foo'
        {}
      end
      
      item = Ketchup::Item.new @api, @meeting,
        'shortcode_url' => 'foo', 'content' => 'foo'
      item.save
    end
    
    it "should not include read-only attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options.keys.should_not include('created_at')
        {}
      end
      
      item = Ketchup::Item.new @api, @meeting,
        'shortcode_url' => 'foo', 'created_at' => Time.now
      item.save
    end
  end
  
  describe '#destroy' do
    it "should delete the item" do
      @api.should_receive(:delete) do |query, options|
        query.should == '/items/foo.json'
      end
      
      item = Ketchup::Item.new @api, @meeting, 'shortcode_url' => 'foo'
      item.destroy
    end
    
    it "should do nothing if the record isn't already saved" do
      @api.should_not_receive(:delete)
      
      item = Ketchup::Item.new @api, @meeting
      item.destroy
    end
  end
end
