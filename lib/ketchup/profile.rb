class Ketchup::Profile
  attr_reader :api, :single_access_token
  attr_accessor :name, :timezone, :email
  
  def self.load(email, password)
    Ketchup::Profile.new Ketchup::API.new(email, password)
  end
  
  def self.create(email, password, options = {})
    Ketchup::API.post '/users.json', :body => options.merge(
      'email'     => email,
      'password'  => password
    )
  end
  
  def initialize(api)
    @api = api
    
    overwrite @api.get('/profile.json')
  end
  
  def reload!
    @meetings = nil
  end
  
  def meetings
    @meetings ||= Ketchup::MeetingArray.new api
  end
  
  def projects
    @projects ||= api.get('/projects.json').collect { |hash|
      Ketchup::Project.new(api, hash)
    }
  end
  
  def save
    overwrite @api.put('/profile.json', {
      'name'      => name,
      'timezone'  => timezone,
      'email'     => email
    })
  end
  
  private
  
  def overwrite(attributes = {})
    @single_access_token = attributes['single_access_token']
    @name                = attributes['name']
    @timezone            = attributes['timezone']
    @email               = attributes['email']
  end
end
