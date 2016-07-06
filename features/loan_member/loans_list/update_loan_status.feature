# these scenarios don't make sense, a doer should update it
@ignore
Feature: LoanMemberManagesLoanList
  @javascript
  Scenario: update loan status
    When I am at loan list page
      Then I select "closed" at ".loan-status"
      Then I click link with div ".btn-update-loan"
      When I reload the page
      Then I should see "Closed"
