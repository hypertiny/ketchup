require 'spec/spec_helper'

describe Ketchup::Profile do
  describe '.load' do
    it "should return a new instance if valid details are provided" do
      Ketchup::API.stub!(:new => stub('api'))
      
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
end
