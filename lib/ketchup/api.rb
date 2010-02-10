require 'httparty'

class Ketchup::API
  include HTTParty
  base_uri 'https://useketchup.com/api/v1'
  
  def initialize(email, password)
    response = self.class.get '/profile.json', :basic_auth => {
      :username => email,
      :password => password
    }
    
    if response == 'Access Denied'
      raise Ketchup::AccessDenied
    else
      @secret = response['single_access_token']
    end
  end
end
