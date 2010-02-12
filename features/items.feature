Feature: Items
  In order to manage my items
  As an API user
  I want to be able to load, change and save my items
  
  Scenario: Listing Items
    Given an existing meeting for "Trampoline"
      And "Trampoline" has an item "Alpha"
      And "Trampoline" has an item "Beta"
      And an existing meeting for "Rails Camp"
      And "Rails Camp" has an item "Gamma"
    When  I reload all objects
    Then  the "Trampoline" meeting should have an item "Alpha"
      And the "Trampoline" meeting should have an item "Beta"
      And the "Trampoline" meeting should not have an item "Gamma"
    
  Scenario: Editing an Item
    Given an existing meeting for "Trampoline"
      And "Trampoline" has an item "Venuu"
    When  I rename item "Venuu" for "Trampoline" to "Venue"
      And I reload all objects
    Then  the "Trampoline" meeting should have an item "Venue"
      And the "Trampoline" meeting should not have an item "Venuu"
  
  Scenario: Deleting an Item
    Given an existing meeting for "Trampoline"
      And "Trampoline" has an item "Alpha"
      And "Trampoline" has an item "Beta"
    When  I delete item "Alpha" from "Trampoline"
      And I reload all objects
    Then  the "Trampoline" meeting should have an item "Beta"
      And the "Trampoline" meeting should not have an item "Alpha"
  
