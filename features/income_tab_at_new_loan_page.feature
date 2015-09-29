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
        And I fill in "Job Title" with "Software Engineer"
        And I fill in "Months at this employer" with "12"
        And I fill in "Contact Name" with "Cuong Vu"
        And I fill in "Contact Phone Number" with "0912345678"
        And I fill in "Annual Gross Income" with "12345432"
      Then I click on "Add other income"
        And I select "Bonus" from "Income Type"
        And I fill in "Annual Gross Amount" with "9876789"
        And I click on "Save and Continue"
        And I wait for 1 seconds
      Then I should see "We’re now ready to get a real-time credit check to verify your credit score and review your credit history"
