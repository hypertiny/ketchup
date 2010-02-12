module Ketchup
  class AccessDenied < StandardError
  end
  
  def self.authenticate(email, password)
    Ketchup::Profile.load(email, password)
  end
end

require 'ketchup/api'
require 'ketchup/item'
require 'ketchup/item_array'
require 'ketchup/meeting'
require 'ketchup/meeting_array'
require 'ketchup/note'
require 'ketchup/profile'
require 'ketchup/project'
