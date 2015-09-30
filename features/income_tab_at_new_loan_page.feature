Feature: IncomeTabAtNewLoanPage
  @javascript
  Scenario: User submits PDF files
    When I am at loan management page
      And I click on "Income" in the "#tabIncome"
      Then I drag the file "spec/files/sample.png" to "first_paystub"
        And I wait for 2 seconds
        And I should see "sample.png"
      Then I drag the file "spec/files/sample.pdf" to "first_bank_statement"
        And I wait for 2 seconds
        And I should see "sample.pdf"
      Then I fill in "Name of current employer" with "Any Company"
        Then I clear value in "Job Title"
          And I fill in "Job Title" with "Software Engineer"
        Then I clear value in "Months at this employer"
          And I fill in "Months at this employer" with "12"
        Then I clear value in "Contact Name"
          And I fill in "Contact Name" with "Cuong Vu"
        Then I clear value in "Contact Phone Number"
          And I fill in "Contact Phone Number" with "0912345678"
        Then I clear value in "Annual Gross Income"
          And I fill in "Annual Gross Income" with "123454"
      Then I click on "Save and Continue"
        And I wait for 1 seconds
      Then I should see "Current Bank Balance"
        And I click on "Income" in the "#tabIncome"
        Then I should see "Software Engineer"
          And I should see "Cuong Vu"
          And I should see "0912345678"
          And I should see "$123,454"
