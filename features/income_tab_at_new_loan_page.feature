Feature: IncomeTabAtNewLoanPage
  @javascript
  Scenario: User submits PDF files
    When I am at loan management page
      And I should see "Income"
      And I click on "Income" in the "#tabIncome"
      Then I fill in "Name of current employer" with "Any Company"
        Then I clear value in "Job Title"
          And I fill in "Job Title" with "Software Engineer"
        Then I clear value in "Years at this employer"
          And I fill in "Years at this employer" with "12"
        Then I clear value in "Contact Name"
          And I fill in "Contact Name" with "Cuong Vu"
        Then I clear value in "Contact Phone Number"
          And I fill in "Contact Phone Number" with "0912345678"
        Then I clear value in "Base Income"
          And I fill in "Base Income" with "123454"
      Then I click on "Save and Continue"
        And I wait for 2 seconds
      And I click on "Income" in the "#tabIncome"
        Then I should see "Software Engineer"
          And I should see "Cuong Vu"
          And I should see "0912345678"
          And I should see "$123,454"
      And I should see "Documents"
      And I click on "Documents" in the "#tabDocuments"
      And I wait for 5 seconds
      Then I drag the file "spec/files/sample.pdf" to "first_bank_statement"
        And I wait for 2 seconds
        And I should see "sample.pdf"