require 'spec/spec_helper'

describe Ketchup::API do
  describe '#initialize' do
    it "should return a new API object on success" do
      FakeWeb.register_uri :get, /#{KetchupAPI}\/profile.json$/,
        :body => '{"single_access_token":"foo"}'
      
      Ketchup::API.new('user@domain.com', 'secret').should be_a(Ketchup::API)
    end
    
    it "should raise an exception on failure" do
      FakeWeb.register_uri :get, /#{KetchupAPI}\/profile.json$/,
        :body => 'Access Denied'
      
      lambda {
        Ketchup::API.new('user@domain.com', 'secret')
      }.should raise_error(Ketchup::AccessDenied)
    end
  end
end
