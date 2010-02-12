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
end
