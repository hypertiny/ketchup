require 'httparty'

# The direct interface with Ketchup's RESTful API. You should generally not have
# any need to use this class yourself, unless you're playing around with the
# internals. That said, it's a simple class - with get, post, put and delete
# instance methods for matching HTTP requests, that automatically include the
# access token.
# 
# For pure access to the API, without any implicit authentication, use the class
# level methods, which are provided by the mixed-in HTTParty module.
# 
# @see http://rdoc.info/projects/jnunemaker/httparty HTTParty
# 
class Ketchup::API
  include HTTParty
  base_uri 'https://useketchup.com/api/v1'
  
  attr_reader :access_token
  
  # Creates a new API instance for the given profile, as determined by the email
  # and password. This API object can then be used by all other objects to
  # interact with the API without having to re-authenticate.
  # 
  # @param [String] email The user's email address
  # @param [String] password The user's password
  # @raise [Ketchup::AccessDenied] if the email or password are incorrect
  # 
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
  
  # Execute a GET request to the API server using the stored access token.
  # 
  # @param [String] path The URL path
  # @param [Hash] data Parameters for the request
  # @return The web response
  # 
  def get(path, data = {})
    self.class.get path, :query => data.merge(:u => access_token)
  end
  
  # Execute a POST request to the API server using the stored access token.
  # 
  # @param [String] path The URL path
  # @param [Hash] data Parameters for the request
  # @return The web response
  # 
  def post(path, data = {})
    self.class.post path, :body => data.merge(:u => access_token)
  end
  
  # Execute a PUT request to the API server using the stored access token.
  # 
  # @param [String] path The URL path
  # @param [Hash] data Parameters for the request
  # @return The web response
  # 
  def put(path, data = {})
    self.class.put path, :body => data.merge(:u => access_token)
  end
  
  # Execute a DELETE request to the API server using the stored access token.
  # 
  # @param [String] path The URL path
  # @param [Hash] data Parameters for the request
  # @return The web response
  #
  def delete(path, data = {})
    self.class.delete path, :body => data.merge(:u => access_token)
  end
end
