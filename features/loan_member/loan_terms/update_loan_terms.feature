Feature: UpdateLoanTerms
  @javascript
  Scenario: update loan terms
    When I am at loan member dashboard
      Then I click "Loan Terms"
      And I should see "Loan Summary"
      And I fill in "Property Value" with "$999,999"
      And I fill in "Loan Amount" with "$888,888"
      And I fill in "Interest Rate (%)" with "3.4"
      And I select "7/1 ARM" from "Loan Type"
      And I fill in "Lender Credits / Discount Points" with "$777,777"
      And I fill in "Lender Fees" with "$666,666"
      And I fill in "Down Payment" with "$555,555"
      And I fill in "Total Cash to Close (est.)" with "$444,444"
      And I fill in "Principal and Interest" with "$333,333"
      And I fill in "Homeowners Insurance" with "$222,222"
      And I fill in "Property Tax" with "$111,111"
      And I fill in "HOA Due" with "$99,999"
      And I fill in "Mortgage Insurance" with "$88,888"
      And I click on the element "#submit-loan-terms"
      And I wait for 2 seconds
      And I reload the page
      And I confirm the browser dialog
      And I should see "Loan Terms"
      Then I click "Loan Terms"
      And I should see "$999,999.00"
      And I should see "$888,888.00"
      And I should see "$777,777.00"
      And I should see "$666,666.00"
      And I should see "$555,555.00"
      And I should see "$444,444.00"
      And I should see "$333,333.00"
      And I should see "$222,222.00"
      And I should see "$111,111.00"
      And I should see "$99,999.00"
      And I should see "$88,888.00"
