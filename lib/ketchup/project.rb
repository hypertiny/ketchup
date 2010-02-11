class Ketchup::Project
  attr_accessor :name
  attr_reader :shortcode_url, :created_at, :updated_at
  
  def initialize(api, params = {})
    @api = api
    
    overwrite params
  end
  
  def save
    overwrite @api.put("/projects/#{shortcode_url}.json", 'name' => name)
  end
  
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
