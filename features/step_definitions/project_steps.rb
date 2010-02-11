Given /^a meeting "([^\"]*)" in the "([^\"]*)" project$/ do |title, project|
  @profile.meetings.create 'title' => title, 'project_name' => project
end

When /^I rename the "([^\"]*)" project to "([^\"]*)"$/ do |old_name, new_name|
  project = @profile.projects.detect { |project|
    project.name == old_name
  }
  project.name = new_name
  project.save
end

Then /^I should have a project "([^\"]*)"$/ do |name|
  @profile.projects.detect { |project|
    project.name == name
  }.should_not be_nil
end

Then /^I should not have a project "([^\"]*)"$/ do |name|
  @profile.projects.detect { |project|
    project.name == name
  }.should be_nil
end

Then /^the "([^\"]*)" project should have a meeting for "([^\"]*)"$/ do |project_name, meeting_title|
  @profile.projects.detect { |project|
    project.name == project_name
  }.meetings.detect { |meeting|
    meeting.title == meeting_title
  }.should_not be_nil
end

Then /^the "([^\"]*)" project should not have a meeting for "([^\"]*)"$/ do |project_name, meeting_title|
  @profile.projects.detect { |project|
    project.name == project_name
  }.meetings.detect { |meeting|
    meeting.title == meeting_title
  }.should be_nil
end
