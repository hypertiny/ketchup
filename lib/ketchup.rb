# Ketchup Ruby API
# 
# @author Pat Allan
# @see http://useketchup.com
# 
module Ketchup
  # An exception thrown when invalid authentication details are provided.
  # 
  class AccessDenied < StandardError
  end
  
  # Creates a new profile authenticated against the Ketchup API. This is the
  # recommended method to get access to an account's meetings, notes and items.
  # 
  # @example
  #   profile = Ketchup.authenticate 'foo@bar.com', 'secret'
  # 
  # @param [String] email The user's email address
  # @param [String] password The user's passwords
  # @return [Ketchup::Profile] A new profile instance
  # @raise [Ketchup::AccessDenied] when the email or password is incorrect
  # 
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
require 'ketchup/note_array'
require 'ketchup/profile'
require 'ketchup/project'
