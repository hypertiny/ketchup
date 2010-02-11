Given /^an existing meeting for "([^\"]*)"$/ do |title|
  @profile.meetings.create('title' => title)
end

When /^I set the location of "([^\"]*)" to "([^\"]*)"$/ do |title, location|
  meeting = @profile.meetings.detect { |meeting| meeting.title == title }
  meeting.location = location
  meeting.save
end

Then /^I should have a meeting for "([^\"]*)"$/ do |title|
  @profile.meetings.detect { |meeting|
    meeting.title == title
  }.should_not be_nil
end

Then /^the location of "([^\"]*)" is "([^\"]*)"$/ do |title, location|
  meeting = @profile.meetings.detect { |meeting| meeting.title == title }
  meeting.location.should == location
end
