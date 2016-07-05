Feature: DisplayLoanTitle
  @javascript
  Scenario: display borrower's address and loan's title
    When I am at dashboard page
      And I should see "1722 Silver Meadow Way, Apt. 305, Sacramento, CA 95829"
