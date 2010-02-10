require 'spec/spec_helper'

describe Ketchup do
  describe '.authenticate' do
    it "should return a new Profile object on success" do
      Ketchup::API.stub!(:new => stub('api'))
      
      Ketchup.authenticate('user@domain.com', 'secret').
        should be_a(Ketchup::Profile)
    end
    
    it "should raise an exception on failure" do
      Ketchup::API.stub!(:new).and_raise(Ketchup::AccessDenied)
      
      lambda {
        Ketchup.authenticate('user@domain.com', 'secret')
      }.should raise_error(Ketchup::AccessDenied)
    end
  end
end
