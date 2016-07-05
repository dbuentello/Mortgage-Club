Feature: ClickOnTabs
  @javascript
  Scenario: click on tabs
    When I am at dashboard page
    Then I click "Property"
      And I should see "property-document-name"
    Then I click on "Terms"
      And I should see "Your Loan Summary"
      And I should see "1722 Silver Meadow Way, Sacramento, CA 95829"
      And I should see "Principal and Interest"
      And I should see "$5,356.00"
    Then I click on "Contacts"
      And I should see "Michael Gifford"
