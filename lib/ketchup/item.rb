class Ketchup::Item
  attr_reader :shortcode_url, :updated_at, :created_at, :meeting_id, :notes,
    :position, :meeting, :api
  attr_accessor :content
  
  def initialize(api, meeting, params = {})
    @api     = api
    @meeting = meeting
    
    overwrite params
    
    @notes = (params['notes'] || []).collect { |hash|
      Ketchup::Note.new api, self, hash
    }
  end
  
  def new_record?
    shortcode_url.nil?
  end
  
  def save
    if new_record?
      overwrite @api.post("/meetings/#{meeting.shortcode_url}/items.json",
        'content' => content)
    else
      overwrite @api.put("/items/#{shortcode_url}.json", 'content' => content)
    end
  end
  
  private
  
  def overwrite(attributes = {})
    @shortcode_url = attributes['shortcode_url']
    @created_at    = attributes['created_at']
    @updated_at    = attributes['updated_at']
    @meeting_id    = attributes['meeting_id']
    @position      = attributes['position']
    @content       = attributes['content']
  end
end
