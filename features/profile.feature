Feature: User Profile
  In order to manage my details
  As an API user
  I want to be able to create, view and change my profile information
  
  Scenario: Editing a User's Details
    When  I change my email to "sauce@freelancing-gods.com"
      And I reconnect to the API
    Then  my email should be "sauce@freelancing-gods.com"
      And I change my email to "ketchup@freelancing-gods.com"
      And I reconnect to the API
  
  Scenario: Changing a User's Password
    When  I change my password to "temporary"
      And I reconnect to the API with "temporary"
    Then  there should be no exceptions
      And I change my password to "password"
  
