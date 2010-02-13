When /^I reload all objects$/ do
  @profile.reload!
end

Then /^there should be no exceptions$/ do
  # Nothing happens here, but this step should be reached. Scenarios read oddly
  # otherwise.
end
