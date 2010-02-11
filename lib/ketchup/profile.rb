class Ketchup::Profile
  attr_reader :api
  
  def self.load(email, password)
    Ketchup::Profile.new Ketchup::API.new(email, password)
  end
  
  def initialize(api)
    @api = api
  end
  
  def reload!
    @meetings = nil
  end
  
  def meetings
    @meetings ||= api.get('/meetings.json').collect { |hash|
      Ketchup::Meeting.new(api, hash)
    }
  end
end
