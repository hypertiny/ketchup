require 'spec/spec_helper'

describe Ketchup::NoteArray do
  before :each do
    @api     = stub('api', :get => [])
    @meeting = Ketchup::Meeting.new @api
    @item    = Ketchup::Item.new @api, @meeting, 'shortcode_url' => 'bar'
  end
  
  it "should be a subclass of Array" do
    Ketchup::NoteArray.superclass.should == Array
  end
  
  describe '#initialize' do
    it "should instantiate notes from the provided array" do
      time  = Time.now
      notes = Ketchup::NoteArray.new @api, @item, [{
        'updated_at'    => time,
        'shortcode_url' => 'ZCTYXAeDb_rQ3IkRq9nutcwfxUpNPLBOsHM28Ela',
        'content'       => 'Foo',
        'position'      => 1,
        'item_id'       => 4321,
        'created_at'    => time
      }]
      notes.first.should be_a(Ketchup::Note)
    end
  end
  
  describe '#build' do
    before :each do
      @notes = Ketchup::NoteArray.new @api, @item
    end
    
    it "should set the note's API object" do
      note = @notes.build 'content' => 'foo'
      note.api.should == @api
    end
    
    it "should pass on the options to the new note" do
      note = @notes.build 'content' => 'foo'
      note.content.should == 'foo'
    end
    
    it "should add the note to the array" do
      note = @notes.build 'content' => 'foo'
      @notes.should include(note)
    end
  end
  
  describe '#create' do
    before :each do
      @api.stub!(:post => {'content' => 'foo'})
      @notes = Ketchup::NoteArray.new @api, @item
    end
    
    it "should set the note's API object" do
      note = @notes.create 'content' => 'foo'
      note.api.should == @api
    end
    
    it "should pass on the options to the new note" do
      note = @notes.create 'content' => 'foo'
      note.content.should == 'foo'
    end
    
    it "should add the note to the array" do
      note = @notes.create 'content' => 'foo'
      @notes.should include(note)
    end
    
    it "should have already saved the item" do
      @api.should_receive(:post)
      
      note = @notes.create 'content' => 'foo'
    end
  end
  
  describe '#reorder' do
    before :each do
      @api.stub!(:put => [])
      @notes = Ketchup::NoteArray.new @api, @item, [
        {'shortcode_url' => 'alpha', 'content' => 'Alpha'},
        {'shortcode_url' => 'beta',  'content' => 'Beta' },
        {'shortcode_url' => 'gamma', 'content' => 'Gamma'}
      ]
      @alpha, @beta, @gamma = @notes
    end
    
    it "should send a put request to the correct url" do
      @api.should_receive(:put) do |query, options|
        query.should == '/items/bar/sort_notes.json'
      end
      
      @notes.reorder @beta, @gamma, @alpha
    end
    
    it "should send the shortcode urls in the given order" do
      @api.should_receive(:put) do |query, options|
        options['notes'].should == ['beta', 'gamma', 'alpha']
      end
      
      @notes.reorder @beta, @gamma, @alpha
    end
    
    it "should change the order of the array" do
      @notes.reorder @beta, @gamma, @alpha
      @notes[0].should == @beta
      @notes[1].should == @gamma
      @notes[2].should == @alpha
    end
    
    it "should raise an error if not the same notes" do
      note = Ketchup::Note.new @api, @item, 'shortcode_url' => 'delta'
      lambda {
        @notes.reorder note, @beta, @alpha
      }.should raise_error(ArgumentError)
    end
    
    it "should raise an error if not all the notes" do
      lambda {
        @notes.reorder @alpha, @gamma
      }.should raise_error(ArgumentError)
    end
  end
end
