class Ketchup::Profile
  def self.load(email, password)
    Ketchup::Profile.new Ketchup::API.new(email, password)
  end
  
  def initialize(api)
    @api = api
  end
end
