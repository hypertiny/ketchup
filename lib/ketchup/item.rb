# Represents a list/agenda item in a meeting. Only the content is editable.
# 
# If you want to change the order of items, you can do that using
# Ketchup::ItemArray (the meeting's item array).
# 
class Ketchup::Item
  attr_reader :shortcode_url, :updated_at, :created_at, :meeting_id, :notes,
    :position, :meeting, :api
  attr_accessor :content
  
  # Create a new item for a given meeting, using an existing api connection. You
  # generally won't want to call this yourself - the better interface to create
  # new items is via a meeting's item array.
  # 
  # However, if you are doing some internal hacking, it's worth noting that all
  # keys for parameters in the hash should be strings, not symbols.
  # 
  # @example
  #   Ketchup::Item.new api, meeting, 'content' => "Treasurer's Report"
  # 
  # @param [Ketchup::API] api The API connection
  # @param [Ketchup::Meeting] meeting The meeting the item will belong to
  # @param [Hash] params Any other details for the item.
  # @see Ketchup::ItemArray#build
  # @see Ketchup::ItemArray#create
  # 
  def initialize(api, meeting, params = {})
    @api     = api
    @meeting = meeting
    
    overwrite params
    
    @notes = Ketchup::NoteArray.new @api, self, (params['notes'] || [])
  end
  
  # Indicates whether the item exists on the server yet.
  # 
  # @return [Boolean] True if the item does not exist on the server.
  # 
  def new_record?
    shortcode_url.nil?
  end
  
  # Saves the item to the server, whether it's a new item or an existing one.
  # This does not save underlying notes.
  # 
  def save
    if new_record?
      overwrite @api.post("/meetings/#{meeting.shortcode_url}/items.json",
        'content' => content)
    else
      overwrite @api.put("/items/#{shortcode_url}.json", 'content' => content)
    end
  end
  
  # Deletes the item from the server. If the item has never been saved, this
  # method will do nothing at all.
  # 
  def destroy
    return if new_record?
    
    @api.delete "/items/#{shortcode_url}.json"
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
