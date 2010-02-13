require 'spec/spec_helper'

describe Ketchup::ItemArray do
  before :each do
    @api     = stub('api', :get => [])
    @meeting = Ketchup::Meeting.new @api, 'shortcode_url' => 'bar'
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
  
  describe '#reorder' do
    before :each do
      @api.stub!(:put => [])
      @items = Ketchup::ItemArray.new @api, @meeting, [
        {'shortcode_url' => 'alpha', 'content' => 'Alpha'},
        {'shortcode_url' => 'beta',  'content' => 'Beta' },
        {'shortcode_url' => 'gamma', 'content' => 'Gamma'}
      ]
      @alpha, @beta, @gamma = @items
    end
    
    it "should send a put request to the correct url" do
      @api.should_receive(:put) do |query, options|
        query.should == '/meetings/bar/sort_items.json'
      end
      
      @items.reorder @beta, @gamma, @alpha
    end
    
    it "should send the shortcode urls in the given order" do
      @api.should_receive(:put) do |query, options|
        options['items'].should == ['beta', 'gamma', 'alpha']
      end
      
      @items.reorder @beta, @gamma, @alpha
    end
    
    it "should change the order of the array" do
      @items.reorder @beta, @gamma, @alpha
      @items[0].should == @beta
      @items[1].should == @gamma
      @items[2].should == @alpha
    end
    
    it "should raise an error if not the same items" do
      item = Ketchup::Item.new @api, @meeting, 'shortcode_url' => 'delta'
      lambda {
        @items.reorder item, @beta, @alpha
      }.should raise_error(ArgumentError)
    end
    
    it "should raise an error if not all the items" do
      lambda {
        @items.reorder @alpha, @gamma
      }.should raise_error(ArgumentError)
    end
  end
end
