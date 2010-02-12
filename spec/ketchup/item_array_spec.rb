require 'spec/spec_helper'

describe Ketchup::ItemArray do
  before :each do
    @api     = stub('api', :get => [])
    @meeting = Ketchup::Meeting.new @api
  end
  
  it "should be a subclass of Array" do
    Ketchup::ItemArray.superclass.should == Array
  end
  
  describe '#initialize' do
    it "should instantiate items from the provided array" do
      time  = Time.now
      items = Ketchup::ItemArray.new @api, @meeting, [{
        'updated_at' => time,
        'shortcode_url' => 'ZCTYXAeDb_rQ3IkRq9nutcwfxUpNPLBOsHM28Ela',
        'notes'         => [],
        'content'       => 'Foo',
        'position'      => 1,
        'meeting_id'    => 4321,
        'created_at'    => time
      }]
      items.first.should be_a(Ketchup::Item)
    end
  end
  
  describe '#build' do
    before :each do
      @items = Ketchup::ItemArray.new @api, @meeting
    end
    
    it "should set the item's API object" do
      item = @items.build 'content' => 'foo'
      item.api.should == @api
    end
    
    it "should pass on the options to the new item" do
      item = @items.build 'content' => 'foo'
      item.content.should == 'foo'
    end
    
    it "should add the item to the array" do
      item = @items.build 'content' => 'foo'
      @items.should include(item)
    end
  end
  
  describe '#create' do
    before :each do
      @api.stub!(:post => {'content' => 'foo'})
      @items = Ketchup::ItemArray.new @api, @meeting
    end
    
    it "should set the item's API object" do
      item = @items.create 'content' => 'foo'
      item.api.should == @api
    end
    
    it "should pass on the options to the new item" do
      item = @items.create 'content' => 'foo'
      item.content.should == 'foo'
    end
    
    it "should add the item to the array" do
      item = @items.create 'content' => 'foo'
      @items.should include(item)
    end
    
    it "should have already saved the item" do
      @api.should_receive(:post)
      
      item = @items.create 'content' => 'foo'
    end
  end
end
