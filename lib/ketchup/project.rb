# Represents a project, which meetings can be grouped under.
# 
# Projects cannot be created manually - just create meetings with project names,
# and the corresponding projects will be created if they don't already exist.
# 
# You can, however, change the name of a project.
# 
class Ketchup::Project
  attr_accessor :name
  attr_reader :shortcode_url, :created_at, :updated_at
  
  # Set up a new Project object - although there's not much point calling this
  # yourself, as it's only useful when populating with data from the server.
  # 
  # @param [Ketchup::API] api An established API connection.
  # @param [Hash] params The project details
  # 
  def initialize(api, params = {})
    @api = api
    
    overwrite params
  end
  
  # Saves any changes to the project's name.
  # 
  def save
    overwrite @api.put("/projects/#{shortcode_url}.json", 'name' => name)
  end
  
  # Gets all the meetings tied to this particular project. This is not a special
  # array, so it's best to create new meetings for a given project via the
  # profile's meetings collection object instead.
  # 
  # @return [Array] Meetings associated with this project.
  # 
  def meetings
    @meetings ||= @api.get("/projects/#{shortcode_url}/meetings.json").
      collect { |hash|
        Ketchup::Meeting.new @api, hash
      }
  end
  
  private
  
  def overwrite(attributes = {})
    @shortcode_url = attributes['shortcode_url']
    @created_at    = attributes['created_at']
    @updated_at    = attributes['updated_at']
    @name          = attributes['name']
  end
end
