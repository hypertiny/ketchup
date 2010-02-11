Feature: Projects
  In order to manage my projects
  As an API user
  I want to be able to load, change and save my projects
  
  Scenario: Listing Projects
    Given a meeting "Rails Camp Planning" in the "Ruby" project
      And a meeting "RoRO Meet" in the "Ruby" project
      And a meeting "Trampoline Debrief" in the "Trampoline" project
    When  I reload all objects
    Then  I should have a project "Ruby"
      And I should have a project "Trampoline"
  
  Scenario: Editing a Project
    Given a meeting "Rails Camp Planning" in the "Rails" project
    When  I rename the "Rails" project to "Ruby"
      And I reload all objects
    Then  I should have a project "Ruby"
      And I should not have a project "Rails"
  
  Scenario: Listing Meetings in a Project
    Given a meeting "Rails Camp Planning" in the "Ruby" project
      And a meeting "RoRO Meet" in the "Ruby" project
      And a meeting "Trampoline Debrief" in the "Trampoline" project
    When  I reload all objects
    Then  the "Ruby" project should have a meeting for "Rails Camp Planning"
      And the "Ruby" project should have a meeting for "RoRO Meet"
      And the "Ruby" project should not have a meeting for "Trampoline Debrief"
  
