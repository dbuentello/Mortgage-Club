Feature: Dashboard
  @javascript
  Scenario: destroy a loan
    When I am at dashboard page
      And I click on "Delete Loan"
      And I click on "Yes"
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
    Then I should see "Real Estates"
      And I should see "ESigning"

  @javascript
  Scenario: click on tabs
    When I am at dashboard page
    Then I click on "Property"
      And I should see "property-document-name"
    Then I click on "Borrower"
      And I should see "borrower-document-name"
    Then I click "Loan"
      And I should see "loan-document-name"
    Then I click on "Closing"
      And I should see "closing-document-name"
    Then I click on "Contacts"
      And I should see "Michael Gifford"
