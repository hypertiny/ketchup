class Ketchup::ItemArray < Array
  def initialize(api, meeting, items = [])
    @api     = api
    @meeting = meeting
    
    replace items.collect { |hash|
      Ketchup::Item.new(@api, @meeting, hash)
    }
  end
  
  def build(params = {})
    item = Ketchup::Item.new @api, @meeting, params
    push item
    item
  end
  
  def create(params = {})
    item = build(params)
    item.save
    item
  end
  
  def reorder(*items)
    if items.collect(&:shortcode_url).sort != collect(&:shortcode_url).sort
      raise ArgumentError, 'cannot sort a different set of items'
    end
    
    @api.put "/meetings/#{@meeting.shortcode_url}/sort_items.json", {
      'items' => items.collect(&:shortcode_url)
    }
    replace items
  end
end
