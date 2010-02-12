Given /^"([^\"]*)" has an item "([^\"]*)"$/ do |title, item|
  @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.create 'content' => item
end

When /^I rename item "([^\"]*)" for "([^\"]*)" to "([^\"]*)"$/ do |old_content, title, new_content|
  item = @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == old_content
  }
  item.content = new_content
  item.save
end

When /^I delete item "([^\"]*)" from "([^\"]*)"$/ do |content, title|
  @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == content
  }.destroy
end

Then /^the "([^\"]*)" meeting should have an item "([^\"]*)"$/ do |title, content|
  @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == content
  }.should_not be_nil
end

Then /^the "([^\"]*)" meeting should not have an item "([^\"]*)"$/ do |title, content|
  @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == content
  }.should be_nil
end
