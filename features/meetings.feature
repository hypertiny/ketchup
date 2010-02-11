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
  
  Scenario: Deleting Meetings
    Given an existing meeting for "An Important Discussion"
    When  I reload all objects
      And I destroy the meeting for "An Important Discussion"
      And I reload all objects
    Then I should not have a meeting for "An Important Discussion"
  
  Scenario: Upcoming Meetings
    Given an existing meeting for "Trampoline Planning" three days ago
      And an existing meeting for "Rails Camp Planning" in two days
    When  I reload all objects
    Then  I should see "Rails Camp Planning" in my upcoming meetings
      And I should not see "Trampoline Planning" in my upcoming meetings
  
  Scenario: Previous Meetings
    Given an existing meeting for "Trampoline Planning" three days ago
      And an existing meeting for "Rails Camp Planning" in two days
    When  I reload all objects
    Then  I should not see "Rails Camp Planning" in my previous meetings
      And I should see "Trampoline Planning" in my previous meetings
  
  Scenario: Today's Meetings
    Given an existing meeting for "Trampoline Planning" three days ago
      And an existing meeting for "Rails Camp Planning" in two days
      And an existing meeting for "FunConf Planning" today
    When  I reload all objects
    Then  I should not see "Rails Camp Planning" in today's meetings
      And I should not see "Trampoline Planning" in today's meetings
      And I should see "FunConf Planning" in today's meetings
  
