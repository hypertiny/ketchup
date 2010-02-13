# A collection of notes for a specific item, and allows for the creation of
# new notes, and re-ordering of the full set of notes. It's really just a
# slightly special subclass of Array.
# 
class Ketchup::NoteArray < Array
  # Create a new NoteArray for a given api, item, and set of notes. The set
  # of notes should be hashes taken from the API server, not actual note
  # objects.
  # 
  # Like many of the methods in this library, you really don't need to call this
  # one yourself. An item object will create its own NoteArray without any
  # help.
  # 
  # @example
  #   Ketchup::NoteArray.new api, item, [{'content' => 'foo', #... }]
  # 
  # @param [Ketchup::API] api A connected API instance
  # @param [Ketchup::Item] item The item all notes are attached to.
  # @param [Array] items An array of hashes that map to attributes of notes.
  # 
  def initialize(api, item, notes = [])
    @api  = api
    @item = item
    
    replace notes.collect { |hash|
      Ketchup::Note.new(@api, @item, hash)
    }
  end
  
  # Create a new unsaved note object. The only parameter you really need to
  # worry about is the content - the rest is all internal values, managed by the
  # API server.
  # 
  # @example
  #   item.notes.build 'content' => 'Targets are being met.'
  # 
  # @param [Hash] params The note's details
  # @return [Ketchup::Note] An unsaved note
  # 
  def build(params = {})
    note = Ketchup::Note.new @api, @item, params
    push note
    note
  end
  
  # Create a new (saved) note object. The only parameter you really need to
  # worry about is the content - the rest is all internal values, managed by the
  # API server.
  # 
  # @example
  #   item.notes.create 'content' => 'Targets are being met.'
  # 
  # @param [Hash] params The note's details
  # @return [Ketchup::Note] A saved note
  # 
  def create(params = {})
    note = build(params)
    note.save
    note
  end
  
  # Re-order the notes in this array, by passing them through in the order you
  # would prefer. This makes the change directly to the API server, as well as
  # within this array.
  # 
  # Make sure you're passing in all the notes that are in this array, and no
  # others. This can't be used as a shortcut to add new notes.
  # 
  # @example
  #   item.notes.reorder second_note, fourth_note, first_note, third_note
  # 
  # @param [Ketchup::Note] notes The notes of the array, in a new order.
  # @raise ArgumentError if you don't provide the exact same set of notes.
  # 
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
