class Ketchup::NoteArray < Array
  def initialize(api, item, notes = [])
    @api  = api
    @item = item
    
    replace notes.collect { |hash|
      Ketchup::Note.new(@api, @item, hash)
    }
  end
  
  def build(params = {})
    note = Ketchup::Note.new @api, @item, params
    push note
    note
  end
  
  def create(params = {})
    note = build(params)
    note.save
    note
  end
  
  def reorder(*notes)
    if notes.collect(&:shortcode_url).sort != collect(&:shortcode_url).sort
      raise ArgumentError, 'cannot sort a different set of notes'
    end
    
    @api.put "/items/#{@item.shortcode_url}/sort_notes.json", {
      'notes' => notes.collect(&:shortcode_url)
    }
    replace notes
  end
end
