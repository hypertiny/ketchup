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

When /^I change my password to "([^\"]*)"$/ do |password|
  @profile.change_password password
end

When /^I reconnect to the API with "([^\"]*)"$/ do |password|
  @profile = Ketchup.authenticate(@profile.email, password)
end
