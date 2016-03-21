Feature: DestroyLoan
  @javascript
  Scenario: destroy a loan
    When I am at dashboard page
      And I click on "Delete"
      And I press "Yes" in the modal "deleteLoan"
      And I should be on the borrower root page
