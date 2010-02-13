# A user profile, which provides an interface to the user's meetings and
# projects. You can either create it yourself, using an email and password, or
# through the Ketchup module's authenticate method - they're exactly the same.
# 
# This is the central object for all of your operations through the Ketchup API.
# You don't need to create or manually request any other objects, but instead,
# access them all through the collections on this class.
# 
# @example
#   profile = Ketchup::Profile.load 'foo@bar.com', 'secret'
#   profile.meetings.each do |meeting|
#     puts meeting.title
#   end
# 
class Ketchup::Profile
  attr_reader :api, :single_access_token
  attr_accessor :name, :timezone, :email
  
  # Set up a connection to an existing profile.
  # 
  # @example
  #   profile = Ketchup::Profile.load 'foo@bar.com', 'secret'
  # 
  # @param [String] email The user's email address
  # @param [String] password The user's passwords
  # @return [Ketchup::Profile] A new profile instance
  # @raise [Ketchup::AccessDenied] when the email or password is incorrect
  # 
  def self.load(email, password)
    Ketchup::Profile.new Ketchup::API.new(email, password)
  end
  
  # Create a completely new user account. You (currently) don't need to have
  # any existing authentication to the server to call this method - just specify
  # the new user's email address and password.
  # 
  # Other extra parameters are the name and timezone of the user account, but
  # these are optional.
  # 
  # Please note: This method doesn't return a new profile, just sets the account
  # up.
  # 
  # @example
  #   Ketchup::Profile.create 'bar@foo.com', 'swordfish', 'name' => 'Bruce'
  # 
  # @param [String] email The email address of the new user.
  # @param [String] password The chosen password of the new user.
  # @param [Hash] options Other optional user details, such as the name and
  #   timezone.
  # 
  def self.create(email, password, options = {})
    Ketchup::API.post '/users.json', :body => options.merge(
      'email'     => email,
      'password'  => password
    )
  end
  
  # Set up a new profile object with an active API connection.
  # 
  # @param [Ketchup::API] api An authenticated API object
  # 
  def initialize(api)
    @api = api
    
    overwrite @api.get('/profile.json')
  end
  
  # Reset the meeting and project objects of this profile, allowing them to
  # be reloaded from the server when next requested.
  # 
  def reload!
    @meetings = nil
    @projects = nil
  end
  
  # Get an array of meetings attached to this profile. Note that the returned
  # object is actually an instance of Ketchup::MeetingArray, which has helper
  # methods for creating and re-ordering meetings.
  # 
  # @return [Ketchup::MeetingArray] The collection of meetings.
  # 
  def meetings
    @meetings ||= Ketchup::MeetingArray.new api
  end
  
  # Get an array of projects attached to this profile. This is not a special
  # project array, as you can only edit projects, not create them. They are
  # created explicitly from meetings.
  # 
  # @return [Array] The collection of projects.
  # 
  def projects
    @projects ||= api.get('/projects.json').collect { |hash|
      Ketchup::Project.new(api, hash)
    }
  end
  
  # Saves any profile changes to the name, timezone and/or email. This does not
  # save any changes made to underlying meetings and projects.
  # 
  def save
    overwrite @api.put('/profile.json',
      'name'      => name,
      'timezone'  => timezone,
      'email'     => email
    )
  end
  
  # Change the password for this profile account.
  # 
  # @param [String] password The new password for the account.
  # 
  def change_password(password)
    @api.put '/profile.json', 'password' => password
  end
  
  private
  
  def overwrite(attributes = {})
    @single_access_token = attributes['single_access_token']
    @name                = attributes['name']
    @timezone            = attributes['timezone']
    @email               = attributes['email']
  end
end
