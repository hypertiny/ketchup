require 'spec/spec_helper'

describe Ketchup::API do
  describe '#initialize' do
    it "should return a new API object on success" do
      FakeWeb.register_uri :get, /#{KetchupAPI}\/profile.json$/,
        :body => '{"single_access_token":"foo"}'
      
      Ketchup::API.new('user@domain.com', 'secret').should be_a(Ketchup::API)
    end
    
    it "should set the access token on success" do
      stub_initial_api_request
      
      Ketchup::API.new('user@domain.com', 'secret').
        access_token.should == 'y3chHxh9Qk1Drkg1j0Bw'
    end
    
    it "should raise an exception on failure" do
      FakeWeb.register_uri :get, /#{KetchupAPI}\/profile.json$/,
        :body => 'Access Denied'
      
      lambda {
        Ketchup::API.new('user@domain.com', 'secret')
      }.should raise_error(Ketchup::AccessDenied)
    end
  end
  
  describe '#get' do
    before :each do
      stub_initial_api_request
      @api = Ketchup::API.new('user@domain.com', 'secret')
    end
    
    it "should include the access token" do
      Ketchup::API.should_receive(:get) do |path, options|
        options[:query][:u].should == 'y3chHxh9Qk1Drkg1j0Bw'
      end
      
      @api.get '/'
    end
    
    it "should send through any provided options" do
      Ketchup::API.should_receive(:get) do |path, options|
        options[:query][:page].should == 4
      end
      
      @api.get '/', :page => 4
    end
  end
  
  describe '#post' do
    before :each do
      stub_initial_api_request
      @api = Ketchup::API.new('user@domain.com', 'secret')
    end
    
    it "should include the access token" do
      Ketchup::API.should_receive(:post) do |path, options|
        options[:body][:u].should == 'y3chHxh9Qk1Drkg1j0Bw'
      end
      
      @api.post '/'
    end
    
    it "should send through any provided options" do
      Ketchup::API.should_receive(:post) do |path, options|
        options[:body][:page].should == 4
      end
      
      @api.post '/', :page => 4
    end
  end
  
  describe '#put' do
    before :each do
      stub_initial_api_request
      @api = Ketchup::API.new('user@domain.com', 'secret')
    end
    
    it "should include the access token" do
      Ketchup::API.should_receive(:put) do |path, options|
        options[:body][:u].should == 'y3chHxh9Qk1Drkg1j0Bw'
      end
      
      @api.put '/'
    end
    
    it "should send through any provided options" do
      Ketchup::API.should_receive(:put) do |path, options|
        options[:body][:page].should == 4
      end
      
      @api.put '/', :page => 4
    end
  end
  
  describe '#delete' do
    before :each do
      stub_initial_api_request
      @api = Ketchup::API.new('user@domain.com', 'secret')
    end
    
    it "should include the access token" do
      Ketchup::API.should_receive(:delete) do |path, options|
        options[:body][:u].should == 'y3chHxh9Qk1Drkg1j0Bw'
      end
      
      @api.delete '/'
    end
    
    it "should send through any provided options" do
      Ketchup::API.should_receive(:delete) do |path, options|
        options[:body][:page].should == 4
      end
      
      @api.delete '/', :page => 4
    end
  end
end
