# A collection of meeting for the current profile, which allows for the creation
# of new meetings. It's really just a slightly special subclass of Array.
# 
class Ketchup::MeetingArray < Array
  # Create a new array from a given api connection. This will make the request
  # to the API to retrieve all meetings for the profile.
  # 
  # This isn't something you need to call yourself - just call the meetings
  # method on your profile object instead.
  # 
  # @example
  #   meetings = Ketchup::MeetingArray.new api
  # 
  # @param [Ketchup::API] api an API instance
  # @see Ketchup::Profile#meetings
  # 
  def initialize(api)
    @api = api
    
    replace @api.get('/meetings.json').collect { |hash|
      Ketchup::Meeting.new(@api, hash)
    }
  end
  
  # Create a new unsaved meeting object. The only parameters you really need to
  # worry about are the title and date - the rest are optional, but mentioned in
  # the notes for the Meeting class.
  # 
  # Don't forget: the parameter keys need to be strings, not symbols.
  # 
  # @example
  #   profile.meetings.build 'title' => 'Job Interview', 'date' => 'Tomorrow'
  # 
  # @param [Hash] params The meeting's details
  # @return [Ketchup::Meeting] An unsaved meeting
  # @see Ketchup::Meeting
  # 
  def build(params = {})
    meeting = Ketchup::Meeting.new @api, params
    push meeting
    meeting
  end
  
  # Create a new (saved) meeting object. The only parameters you really need to
  # worry about are the title and date - the rest are optional, but mentioned in
  # the notes for the Meeting class.
  # 
  # Don't forget: the parameter keys need to be strings, not symbols.
  # 
  # @example
  #   profile.meetings.create 'title' => 'Job Interview', 'date' => 'Tomorrow'
  # 
  # @param [Hash] params The meeting's details
  # @return [Ketchup::Meeting] A saved meeting
  # @see Ketchup::Meeting
  # 
  def create(params = {})
    meeting = build(params)
    meeting.save
    meeting
  end
  
  # Requests a set of meetings that happen on days after today from the API.
  # 
  # @return [Array] An array of upcoming meetings
  # 
  def upcoming
    @upcoming ||= @api.get('/meetings/upcoming.json').collect { |hash|
      Ketchup::Meeting.new(@api, hash)
    }
  end
  
  # Requests a set of meetings that have already happened from the API.
  # 
  # @return [Array] An array of previous meetings
  # 
  def previous
    @previous ||= @api.get('/meetings/previous.json').collect { |hash|
      Ketchup::Meeting.new(@api, hash)
    }
  end
  
  # Requests a set of meetings that will happen today from the API.
  # 
  # @return [Array] An array of today's meetings
  # 
  def today
    @today ||= @api.get('/meetings/todays.json').collect { |hash|
      Ketchup::Meeting.new(@api, hash)
    }
  end
end
