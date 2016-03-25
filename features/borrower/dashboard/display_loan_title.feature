Feature: DisplayLoanTitle
  @javascript
  Scenario: display borrower's address and loan's title
    When I am at dashboard page
      And I should see "81458 Borer Falls, Apt. 305, West Emiltown, Virginia 9999"
