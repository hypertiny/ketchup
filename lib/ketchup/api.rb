require 'httparty'

class Ketchup::API
  include HTTParty
  base_uri 'https://useketchup.com/api/v1'
  
  attr_reader :access_token
  
  def initialize(email, password)
    response = self.class.get '/profile.json', :basic_auth => {
      :username => email,
      :password => password
    }
    
    if response == 'Access Denied'
      raise Ketchup::AccessDenied
    else
      @access_token = response['single_access_token']
    end
  end
  
  def get(path, data = {})
    self.class.get path, :query => data.merge(:u => access_token)
  end
  
  def post(path, data = {})
    self.class.post path, :body => data.merge(:u => access_token)
  end
  
  def put(path, data = {})
    self.class.put path, :body => data.merge(:u => access_token)
  end
  
  def delete(path, data = {})
    self.class.delete path, :body => data.merge(:u => access_token)
  end
end
