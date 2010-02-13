# Represents a note for list/agenda item in a meeting. Only the content is
# editable.
# 
# If you want to change the order of notes, you can do that using
# Ketchup::NoteArray (the item's note array).
# 
class Ketchup::Note
  attr_reader :shortcode_url, :updated_at, :created_at, :item_id, :position,
    :item, :api
  attr_accessor :content
  
  # Create a new note for a given item, using an existing api connection. You
  # generally won't want to call this yourself - the better interface to create
  # new notes is via a item's note array.
  # 
  # However, if you are doing some internal hacking, it's worth noting that all
  # keys for parameters in the hash should be strings, not symbols.
  # 
  # @example
  #   Ketchup::Note.new api, item, 'content' => "Motion passed."
  # 
  # @param [Ketchup::API] api The API connection
  # @param [Ketchup::Item] item The item the note will belong to
  # @param [Hash] params Any other details for the note.
  # @see Ketchup::NoteArray#build
  # @see Ketchup::NoteArray#create
  # 
  def initialize(api, item, params = {})
    @api  = api
    @item = item
    
    overwrite params
  end
  
  # Indicates whether the note exists on the server yet.
  # 
  # @return [Boolean] True if the note does not exist on the server.
  # 
  def new_record?
    shortcode_url.nil?
  end
  
  # Saves the note to the server, whether it's a new note or an existing one.
  # 
  def save
    if new_record?
      overwrite @api.post("/items/#{item.shortcode_url}/notes.json",
        'content' => content)
    else
      overwrite @api.put("/notes/#{shortcode_url}.json", 'content' => content)
    end
  end
  
  # Deletes the note from the server. If the note has never been saved, this
  # method will do nothing at all.
  # 
  def destroy
    return if new_record?
    
    @api.delete "/notes/#{shortcode_url}.json"
  end
  
  private
  
  def overwrite(attributes = {})
    @shortcode_url = attributes['shortcode_url']
    @created_at    = attributes['created_at']
    @updated_at    = attributes['updated_at']
    @item_id       = attributes['item_id']
    @position      = attributes['position']
    @content       = attributes['content']
  end
end
