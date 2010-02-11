require 'rubygems'
require 'cucumber'
require 'spec'

$:.unshift File.dirname(__FILE__) + '/../../lib'

require 'ketchup'

Before do
  @profile = Ketchup.authenticate('ketchup@freelancing-gods.com', 'password')
  
  @profile.meetings.each do |meeting|
    meeting.destroy
  end
  # @profile.projects.each do |project|
  #   project.destroy
  # end
  
  @profile.reload!
end

After do
  @profile.reload!
  
  @profile.meetings.each do |meeting|
    meeting.destroy
  end
end
