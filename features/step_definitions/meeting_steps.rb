Given /^an existing meeting for "([^\"]*)"$/ do |title|
  @profile.meetings.create('title' => title)
end

Given /^an existing meeting for "([^\"]*)" (.+)$/ do |title, date|
  @profile.meetings.create('title' => title, 'date' => date)
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

Then /^I should see "([^\"]*)" in my upcoming meetings$/ do |title|
  @profile.meetings.upcoming.detect { |meeting|
    meeting.title == title
  }.should_not be_nil
end

Then /^I should not see "([^\"]*)" in my upcoming meetings$/ do |title|
  @profile.meetings.upcoming.detect { |meeting|
    meeting.title == title
  }.should be_nil
end

Then /^I should see "([^\"]*)" in my previous meetings$/ do |title|
  @profile.meetings.previous.detect { |meeting|
    meeting.title == title
  }.should_not be_nil
end

Then /^I should not see "([^\"]*)" in my previous meetings$/ do |title|
  @profile.meetings.previous.detect { |meeting|
    meeting.title == title
  }.should be_nil
end

Then /^I should see "([^\"]*)" in today's meetings$/ do |title|
  @profile.meetings.today.detect { |meeting|
    meeting.title == title
  }.should_not be_nil
end

Then /^I should not see "([^\"]*)" in today's meetings$/ do |title|
  @profile.meetings.today.detect { |meeting|
    meeting.title == title
  }.should be_nil
end
