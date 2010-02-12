class Ketchup::Meeting
  attr_reader :shortcode_url, :public_url, :user_id, :created_at, :updated_at,
    :project_id, :items, :api
  
  WriteableAttributes = [:title, :quick, :public, :date, :attendees,
    :description, :project_name, :location]
  attr_accessor *WriteableAttributes
  
  # Could do this all using metaprogramming, but that opens the possibility for
  # security issues. This is a bit more verbose, but it's clear.
  # 
  def initialize(api, params = {})
    @api = api
    
    overwrite params
    
    @items = Ketchup::ItemArray.new @api, self, (params['items'] || [])
  end
  
  def save
    if new_record?
      overwrite @api.post("/meetings.json", writeable_attributes)
    else
      overwrite @api.put("/meetings/#{shortcode_url}.json",
        writeable_attributes)
    end
  end
  
  def destroy
    return if new_record?
    
    @api.delete "/meetings/#{shortcode_url}.json"
  end
  
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
