When /^I change my email to "([^\"]*)"$/ do |email|
  @profile.email = email
  @profile.save
end

When /^I reconnect to the API$/ do
  @profile = Ketchup.authenticate(@profile.email, 'password')
end

Then /^my email should be "([^\"]*)"$/ do |email|
  @profile.email.should == email
end
