Feature: AccessToViewModeLoan
  @javascript
  Scenario: access to  loan's view mode
    When I am at dashboard page
      And I click on "View"
      And I press "Proceed" in the modal "viewLoan"
      Then I click "Property"
        And I should see "Property Address"
        And I should not see "At the minimum"
        And I click on "Next"
        And I should see "At the minimum"
        And I should not see "Property Address"
