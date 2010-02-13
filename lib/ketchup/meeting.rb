# A Meeting - the cornerstone of Ketchup. This object tracks the meeting's
# key details: the title, whether it's public or not, the date, attendees, a
# description, location, project name, and the agenda items.
# 
# While you won't want to create a new meeting from this class itself - it's far
# easier to do so using a profile's meetings array - this is a good reference
# point for changing and deleting meetings.
# 
# @see Ketchup::MeetingArray#build
# @see Ketchup::MeetingArray#create
# 
class Ketchup::Meeting
  attr_reader :shortcode_url, :public_url, :user_id, :created_at, :updated_at,
    :project_id, :items, :api
  
  WriteableAttributes = [:title, :quick, :public, :date, :attendees,
    :description, :project_name, :location]
  attr_accessor *WriteableAttributes
  
  # Create a new meeting, using an active API object. Keep in mind that all
  # parameter keys must be provided as strings. The key attributes are the title
  # and the date (the rest are optional).
  # 
  # The date can be defined using natural language, and the server will figure
  # out what you mean (just like when you create a meeting on the website).
  # 
  # @example
  #   Ketchup::Meeting.new api,
  #     'title'        => 'White Album Cover Brainstorming',
  #     'date'         => 'Tomorrow at 4pm',
  #     'attendees'    => 'John, Paul, George and Ringo',
  #     'location'     => 'Abbey Road',
  #     'project_name' => 'New Releases'
  # 
  # @param [Ketchup::API] api A connected API instance
  # @param [Hash] params The attributes for the meeting.
  # 
  def initialize(api, params = {})
    @api = api
    
    overwrite params
    
    @items = Ketchup::ItemArray.new @api, self, (params['items'] || [])
  end
  
  # Saves the meeting to the server, whether it's a new meeting or an existing
  # one. This does not save underlying items or notes.
  # 
  def save
    if new_record?
      overwrite @api.post("/meetings.json", writeable_attributes)
    else
      overwrite @api.put("/meetings/#{shortcode_url}.json",
        writeable_attributes)
    end
  end
  
  # Deletes the meeting from the server. If the meeting has never been saved,
  # this method will do nothing at all.
  # 
  def destroy
    return if new_record?
    
    @api.delete "/meetings/#{shortcode_url}.json"
  end
  
  # Indicates whether the meeting exists on the server yet.
  # 
  # @return [Boolean] True if the meeting does not exist on the server.
  # 
  def new_record?
    shortcode_url.nil?
  end
  
  private
  
  def overwrite(attributes)
    @shortcode_url = attributes['shortcode_url']
    @public_url    = attributes['public_url']
    @user_id       = attributes['user_id']
    @created_at    = attributes['created_at']
    @updated_at    = attributes['updated_at']
    @project_id    = attributes['project_id']
    
    WriteableAttributes.each do |attrib|
      instance_variable_set "@#{attrib}".to_sym, attributes[attrib.to_s]
    end
  end
  
  def writeable_attributes
    WriteableAttributes.inject({}) do |hash, attrib|
      hash[attrib.to_s] = instance_variable_get "@#{attrib}".to_sym
      hash
    end
  end
end
