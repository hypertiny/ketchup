class Ketchup::Note
  attr_reader :shortcode_url, :updated_at, :created_at, :item_id, :position,
    :item, :api
  attr_accessor :content
  
  def initialize(api, item, params = {})
    @api  = api
    @item = item
    
    overwrite params
  end
  
  def new_record?
    shortcode_url.nil?
  end
  
  def save
    if new_record?
      overwrite @api.post("/items/#{item.shortcode_url}/notes.json",
        'content' => content)
    else
      overwrite @api.put("/notes/#{shortcode_url}.json", 'content' => content)
    end
  end
  
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
