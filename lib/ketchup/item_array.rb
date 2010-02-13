# A collection of items for a specific meeting, and allows for the creation of
# new items, and re-ordering of the full set of items. It's really just a
# slightly special subclass of Array.
# 
class Ketchup::ItemArray < Array
  # Create a new ItemArray for a given api, meeting, and set of items. The set
  # of items should be hashes taken from the API server, not actual item
  # objects.
  # 
  # Like many of the methods in this library, you really don't need to call this
  # one yourself. A meeting object will create its own ItemArray without any
  # help.
  # 
  # @example
  #   Ketchup::ItemArray.new api, meeting, [{'content' => 'foo', #... }]
  # 
  # @param [Ketchup::API] api A connected API instance
  # @param [Ketchup::Meeting] meeting The meeting all items are attached to.
  # @param [Array] items An array of hashes that map to attributes of items.
  # 
  def initialize(api, meeting, items = [])
    @api     = api
    @meeting = meeting
    
    replace items.collect { |hash|
      Ketchup::Item.new(@api, @meeting, hash)
    }
  end
  
  # Create a new unsaved item object. The only parameter you really need to
  # worry about is the content - the rest is all internal values, managed by the
  # API server.
  # 
  # @example
  #   meeting.items.build 'content' => 'Petty Cash'
  # 
  # @param [Hash] params The item's details
  # @return [Ketchup::Item] An unsaved item
  # 
  def build(params = {})
    item = Ketchup::Item.new @api, @meeting, params
    push item
    item
  end
  
  # Create a new (saved) item object. The only parameter you really need to
  # worry about is the content - the rest is all internal values, managed by the
  # API server.
  # 
  # @example
  #   meeting.items.create 'content' => 'Petty Cash'
  # 
  # @param [Hash] params The item's details
  # @return [Ketchup::Item] An item, already saved to the server.
  # 
  def create(params = {})
    item = build(params)
    item.save
    item
  end
  
  # Re-order the items in this array, by passing them through in the order you
  # would prefer. This makes the change directly to the API server, as well as
  # within this array.
  # 
  # Make sure you're passing in all the items that are in this array, and no
  # others. This can't be used as a shortcut to add new items.
  # 
  # @example
  #   meeting.items.reorder second_item, fourth_item, first_item, third_item
  # 
  # @param [Ketchup::Item] items The items of the array, in a new order.
  # @raise ArgumentError if you don't provide the exact same set of items.
  # 
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
