Feature: Meetings
  In order to manage my meetings
  As an API user
  I want to be able to load, change and save my meetings
  
  Scenario: Listing Meetings
    Given an existing meeting for "An Important Discussion"
      And an existing meeting for "Trampoline Planning"
    When  I reload all objects
    Then  I should have a meeting for "An Important Discussion"
      And I should have a meeting for "Trampoline Planning"
  
  Scenario: Editing Meetings
    Given an existing meeting for "An Important Discussion"
    When  I set the location of "An Important Discussion" to "Sugardough"
      And I reload all objects
    Then  the location of "An Important Discussion" is "Sugardough"
  
