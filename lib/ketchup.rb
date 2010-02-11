module Ketchup
  class AccessDenied < StandardError
  end
  
  def self.authenticate(email, password)
    Ketchup::Profile.load(email, password)
  end
end

require 'ketchup/api'
require 'ketchup/meeting'
require 'ketchup/profile'