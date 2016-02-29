Feature: Dashboard
  @javascript
  Scenario: destroy a loan
    When I am at dashboard page
      And I click on "Delete"
      And I press "Yes" in the modal "deleteLoan"

  @javascript
  Scenario: view loan in view mode
    When I am at dashboard page
      And I click on "View"
      Then I click "Property"
        And I should see "Property Address"
        And I should not see "I am applying"
        And I click on "Save and Continue"
        And I should see "Property Address"
        And I should not see "I am applying"

  @javascript
  Scenario: display borrower's address and loan's title
    When I am at dashboard page
      And I should see "81458 Borer Falls, Apt. 305, West Emiltown, Virginia 9999"

  @javascript
  Scenario: click on tabs
    When I am at dashboard page
    Then I click "Property"
      And I should see "property-document-name"
    Then I click on "Contacts"
      And I should see "Michael Gifford"
