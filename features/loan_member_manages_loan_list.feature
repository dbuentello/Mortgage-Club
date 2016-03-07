Feature: LoanMemberManagesLoanList
  @javascript
  Scenario: update loan status
    When I am at loan list page
      Then I select "closed" at ".loan-status"
      Then I click link with div ".btn-update-loan"
  @javascript
  Scenario: display loan status correctly
    When I am at loan list page
      And I should see "Closed"
