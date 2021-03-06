Given /^"([^\"]*)" in "([^\"]*)" has a note "([^\"]*)"$/ do |item_content, title, content|
  @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == item_content
  }.notes.create 'content' => content
end

When /^I rename note "([^\"]*)" for "([^\"]*)" in "([^\"]*)" to "([^\"]*)"$/ do |old_content, item_content, title, new_content|
  note = @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == item_content
  }.notes.detect { |note|
    note.content == old_content
  }
  note.content = new_content
  note.save
end

When /^I delete note "([^\"]*)" from "([^\"]*)" in "([^\"]*)"$/ do |note_content, item_content, title|
  @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == item_content
  }.notes.detect { |note|
    note.content == note_content
  }.destroy
end

When /^I change the note order of "([^\"]*)" in "([^\"]*)" to "([^\"]*)" then "([^\"]*)"$/ do |item_content, title, first, second|
  notes = @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == item_content
  }.notes
  
  first_note  = notes.detect { |note| note.content == first }
  second_note = notes.detect { |note| note.content == second }
  
  notes.reorder first_note, second_note
end

Then /^"([^\"]*)" in "([^\"]*)" should have a note "([^\"]*)"$/ do |item_content, title, note_content|
  @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == item_content
  }.notes.detect { |note|
    note.content == note_content
  }.should_not be_nil
end

Then /^"([^\"]*)" in "([^\"]*)" should not have a note "([^\"]*)"$/ do |item_content, title, note_content|
  @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == item_content
  }.notes.detect { |note|
    note.content == note_content
  }.should be_nil
end

Then /^"([^\"]*)" in "([^\"]*)" should have note "([^\"]*)" before "([^\"]*)"$/ do |item_content, title, first, second|
  notes = @profile.meetings.detect { |meeting|
    meeting.title == title
  }.items.detect { |item|
    item.content == item_content
  }.notes
  
  notes[0].content.should == first
  notes[1].content.should == second
end
