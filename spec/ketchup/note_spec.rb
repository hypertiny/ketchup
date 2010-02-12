require 'spec/spec_helper'

describe Ketchup::Note do
  before :each do
    @api     = stub('api')
    @meeting = Ketchup::Meeting.new @api
    @item    = Ketchup::Item.new @api, @meeting
  end
  
  describe '#initialize' do
    it "should initialize all the attributes" do
      time    = Time.now
      note    = Ketchup::Note.new(@api, @item,
        'updated_at'    => time,
        'shortcode_url' => 'ZTmyXjQEwRuNderHIqvfhlUP0VS172nMD-WLOtio',
        'content'       => 'Foo',
        'position'      => 1,
        'item_id'       => 4321,
        'created_at'    => time
      )
      
      note.updated_at.should == time
      note.shortcode_url.should == 'ZTmyXjQEwRuNderHIqvfhlUP0VS172nMD-WLOtio'
      note.content.should == 'Foo'
      note.position.should == 1
      note.item_id.should == 4321
      note.created_at.should == time
    end
  end
  
  describe '#new_record?' do
    it "should return true if note has no shortcode_url" do
      note = Ketchup::Note.new @api, @item
      note.should be_new_record
    end
    
    it "should return false if note has a shortcode_url" do
      note = Ketchup::Note.new @api, @item, 'shortcode_url' => 'foo'
      note.should_not be_new_record
    end
  end
  
  describe '#save' do
    it "should send a post if creating" do
      @api.should_receive(:post).and_return({})
      
      note = Ketchup::Note.new @api, @item, 'content' => 'foo'
      note.save
    end
    
    it "should include writeable attributes in the post" do
      @api.should_receive(:post) do |query, options|
        options['content'].should == 'foo'
        {}
      end
      
      note = Ketchup::Note.new @api, @item, 'content' => 'foo'
      note.save
    end
    
    it "should not include read-only attributes in the post" do
      @api.should_receive(:post) do |query, options|
        options.keys.should_not include('created_at')
        {}
      end
      
      note = Ketchup::Note.new @api, @item, 'created_at' => Time.now
      note.save
    end
    
    it "should update the object with the response" do
      @api.stub!(:post => {'shortcode_url' => 'foo'})
      
      note = Ketchup::Note.new @api, @item, 'content' => 'Foo'
      note.save
      note.shortcode_url.should == 'foo'
    end
    
    it "should send a put if updating" do
      @api.should_receive(:put).and_return({})
      
      note = Ketchup::Note.new @api, @item, 'shortcode_url' => 'foo'
      note.save
    end
    
    it "should include writeable attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options['content'].should == 'foo'
        {}
      end
      
      note = Ketchup::Note.new @api, @item,
        'shortcode_url' => 'foo', 'content' => 'foo'
      note.save
    end
    
    it "should not include read-only attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options.keys.should_not include('created_at')
        {}
      end
      
      note = Ketchup::Note.new @api, @item,
        'shortcode_url' => 'foo', 'created_at' => Time.now
      note.save
    end
  end
  
  describe '#destroy' do
    it "should delete the note" do
      @api.should_receive(:delete) do |query, options|
        query.should == '/notes/foo.json'
      end
      
      note = Ketchup::Note.new @api, @item, 'shortcode_url' => 'foo'
      note.destroy
    end
    
    it "should do nothing if the record isn't already saved" do
      @api.should_not_receive(:delete)
      
      note = Ketchup::Note.new @api, @item
      note.destroy
    end
  end
end
