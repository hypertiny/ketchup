require 'spec/spec_helper'

describe Ketchup::Project do
  before :each do
    @api = stub('api')
  end
  
  describe '#initialize' do
    it "should initialize all the attributes" do
      time = Time.now
      project = Ketchup::Project.new(@api,
        "name"          => 'Trampoline',
        "updated_at"    => time,
        "shortcode_url" => 'foo',
        "created_at"    => time
      )
      
      project.name.should == 'Trampoline'
      project.updated_at.should == time
      project.created_at.should == time
      project.shortcode_url.should == 'foo'
    end
  end
  
  describe '#save' do
    it "should include writeable attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options['name'].should == 'foo'
        {}
      end
      
      project = Ketchup::Project.new @api, 'name' => 'foo'
      project.save
    end
    
    it "should not include read-only attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options.keys.should_not include('created_at')
        {}
      end
      
      project = Ketchup::Project.new @api, 'created_at' => Time.now
      project.save
    end
    
    it "should update the object with the response" do
      @api.stub!(:put => {'shortcode_url' => 'foo'})
      
      project = Ketchup::Project.new @api, 'name' => 'Foo'
      project.save
      project.shortcode_url.should == 'foo'
    end
  end
  
  describe '#meetings' do
    before :each do
      @api.stub!(:get => [])
    end
    
    it "should request meetings for just the project" do
      @api.should_receive(:get) do |query, options|
        query.should == '/projects/foo/meetings.json'
        []
      end
      
      project = Ketchup::Project.new @api, 'shortcode_url' => 'foo'
      project.meetings
    end
    
    it "should return an array of meetings" do
      project = Ketchup::Project.new @api, 'shortcode_url' => 'foo'
      project.meetings.should be_an(Array)
    end
  end
end
