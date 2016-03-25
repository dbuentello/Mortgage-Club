Feature: DestroyLoan
  @javascript
  Scenario: destroy a loan
    When I am at dashboard page
      And I click on "Delete"
      And I press "Yes" in the modal "deleteLoan"
      And I should see "Property Address"
      And I should not see "Delete"
