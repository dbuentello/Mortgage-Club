Feature: Dashboard
  @javascript
  Scenario: destroy a loan
    When I am at dashboard page
      And I click on "Delete Loan"
      And I press "Yes" in the modal "deleteLoan"
    Then I should be on the my loans page

  @javascript
  Scenario: display borrower's address and loan's title
    When I am at dashboard page
      And I should see content as "81458 Borer Falls, Apt. 305, West Emiltown, Virginia, 9999"
      And I should see content as "$500,000k 2-year fixed 50% LTV Primary Residence Purchase Loan"

  @javascript
  Scenario: edit a loan
    When I am at dashboard page
      And I click on "Edit Loan"

  @javascript
  Scenario: click on tabs
    When I am at dashboard page
    Then I click "Property"
      And I should see "property-document-name"
    Then I click "Borrower"
      And I should see "borrower-document-name"
    Then I click "Loan"
      And I should see "loan-document-name"
    Then I click "Closing"
      And I should see "closing-document-name"
    Then I click on "Contacts"
      And I should see "Michael Gifford"
      And I should see "(manager)"
