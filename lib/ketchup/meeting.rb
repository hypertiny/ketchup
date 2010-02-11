class Ketchup::Meeting
  attr_reader :shortcode_url, :public_url, :user_id, :created_at, :updated_at,
    :project_id, :items
  
  WriteableAttributes = [:title, :quick, :public, :date, :attendees,
    :description, :project_name, :location]
  attr_accessor *WriteableAttributes
  
  # Could do this all using metaprogramming, but that opens the possibility for
  # security issues. This is a bit more verbose, but it's clear.
  # 
  def initialize(api, params = {})
    @api = api
    
    @shortcode_url = params['shortcode_url']
    @public_url    = params['public_url']
    @user_id       = params['user_id']
    @created_at    = params['created_at']
    @updated_at    = params['updated_at']
    @project_id    = params['project_id']
    
    WriteableAttributes.each do |attrib|
      instance_variable_set "@#{attrib}".to_sym, params[attrib.to_s]
    end
    
    @items = (params['items'] || []).collect { |hash|
      Ketchup::Item.new api, hash
    }
  end
  
  def save
    if new_record?
      @api.post "/meetings.json", writeable_attributes
    else
      @api.put  "/meetings/#{shortcode_url}.json", writeable_attributes
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
  
  def writeable_attributes
    WriteableAttributes.inject({}) do |hash, attrib|
      hash[attrib.to_s] = instance_variable_get "@#{attrib}".to_sym
      hash
    end
  end
end
