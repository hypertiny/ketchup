class Ketchup::MeetingArray < Array
  def initialize(api)
    @api = api
    
    replace @api.get('/meetings.json').collect { |hash|
      Ketchup::Meeting.new(api, hash)
    }
  end
  
  def build(params = {})
    meeting = Ketchup::Meeting.new @api, params
    push meeting
    meeting
  end
  
  def create(params = {})
    meeting = build(params)
    meeting.save
    meeting
  end
end
