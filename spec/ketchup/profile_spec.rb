require 'spec/spec_helper'

describe Ketchup::Profile do
  describe '.load' do
    it "should return a new instance if valid details are provided" do
      Ketchup::API.stub!(:new => stub('api', :get => {}))
      
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
  
  describe '.create' do
    it "should send a post" do
      Ketchup::API.should_receive(:post) do |query, options|
        query.should == '/users.json'
        {}
      end
      
      Ketchup::Profile.create 'foo@bar.com', 'password'
    end
    
    it "should include the email and password" do
      Ketchup::API.should_receive(:post) do |query, options|
        options[:body]['email'].should == 'foo@bar.com'
        options[:body]['password'].should == 'secret'
        {}
      end
      
      Ketchup::Profile.create 'foo@bar.com', 'secret'
    end
    
    it "should include any other extra parameters" do
      Ketchup::API.should_receive(:post) do |query, options|
        options[:body]['timezone'].should == 'UTC'
        {}
      end
      
      Ketchup::Profile.create 'foo@bar.com', 'secret', 'timezone' => 'UTC'
    end
  end
  
  describe '#reload!' do
    it "should clear the stored meetings" do
      api = stub('api', :get => {})
      profile = Ketchup::Profile.new(api)
      api.stub!(:get => [])
      
      profile.meetings
      profile.reload!
      
      api.should_receive(:get)
      profile.meetings
    end
  end
  
  describe '#projects' do
    it "should return an array of projects" do
      api     = stub('api', :get => {})
      profile = Ketchup::Profile.new(api)
      api.stub!(:get => [])
      
      profile.projects.should be_a(Array)
    end
  end
  
  describe '#meetings' do
    it "should return a meeting array of meetings" do
      api = stub('api', :get => {})
      profile = Ketchup::Profile.new(api)
      api.stub!(:get => [])
      
      profile.meetings.should be_a(Ketchup::MeetingArray)
    end
  end
  
  describe '#save' do
    before :each do
      @api = stub('api', :get => {
        "name"                => "foo",
        "single_access_token" => "bar"
      })
    end
    
    it "should include writeable attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options['name'].should == 'foo'
        {}
      end
      
      profile = Ketchup::Profile.new @api
      profile.save
    end
    
    it "should not include read-only attributes in the put" do
      @api.should_receive(:put) do |query, options|
        options.keys.should_not include('single_access_token')
        {}
      end
      
      profile = Ketchup::Profile.new @api
      profile.save
    end
    
    it "should update the object with the response" do
      @api.stub!(:put => {'single_access_token' => 'baz'})
      
      profile = Ketchup::Profile.new @api
      profile.save
      profile.single_access_token.should == 'baz'
    end
  end
end
