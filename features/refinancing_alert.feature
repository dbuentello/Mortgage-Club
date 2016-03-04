Feature: RefinancingAlert
  @javascript @vcr
  Scenario: fill in form and see thanks you
  When I go to the refinance alert page
    And I should see "FREE REFINANCE ALERT"
