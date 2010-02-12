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
end
