Feature: Notes
  In order to manage my notes
  As an API user
  I want to be able to load, change and save my notes
  
  Scenario: Listing Notes
    Given an existing meeting for "Trampoline"
      And "Trampoline" has an item "Alpha"
      And "Alpha" in "Trampoline" has a note "Foo"
      And "Alpha" in "Trampoline" has a note "Bar"
      And "Trampoline" has an item "Beta"
      And "Beta" in "Trampoline" has a note "Baz"
    When  I reload all objects
    Then  "Alpha" in "Trampoline" should have a note "Foo"
      And "Alpha" in "Trampoline" should have a note "Bar"
      And "Alpha" in "Trampoline" should not have a note "Baz"
    
  Scenario: Editing a Note
    Given an existing meeting for "Trampoline"
      And "Trampoline" has an item "Alpha"
      And "Alpha" in "Trampoline" has a note "Foo"
    When  I rename note "Foo" for "Alpha" in "Trampoline" to "Bar"
      And I reload all objects
    Then  "Alpha" in "Trampoline" should have a note "Bar"
      And "Alpha" in "Trampoline" should not have a note "Foo"
  
  Scenario: Deleting a Note
    Given an existing meeting for "Trampoline"
      And "Trampoline" has an item "Alpha"
      And "Alpha" in "Trampoline" has a note "Foo"
      And "Alpha" in "Trampoline" has a note "Bar"
    When  I delete note "Foo" from "Alpha" in "Trampoline"
      And I reload all objects
    Then  "Alpha" in "Trampoline" should have a note "Bar"
      And "Alpha" in "Trampoline" should not have a note "Foo"
  
