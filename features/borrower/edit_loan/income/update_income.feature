@ignore
Feature: UpdateIncome
  @javascript
  Scenario: update income
    When I am at loan management page
      And I should see "Income"
      And I click "Income"
      Then I fill in "Name Of Current Employer" with "Any Company"
      Then I clear value in "Job Title"
        And I fill in "Job Title" with "Software Engineer"
      Then I clear value in "Years At This Employer"
        And I fill in "Years At This Employer" with "12"
      Then I clear value in "Base Income"
        And I fill in "Base Income" with "$123,454.00"
      Then I click link with div ".overtime .iconRemove img"
        And I click link with div ".commission .iconRemove img"
        And I click link with div ".bonus .iconRemove img"
      Then I click on "Add Other Income"
        And I should see "Income Type"
        And I select "Interest" from "borrower_other_incomes_type_0"
        And I should see "Annual Gross Amount"
        And I select "Monthly" from "Income Frequency"
        And I clear value in "Annual Gross Amount"
        And I fill in "Annual Gross Amount" with "$9,787.00"
      Then I click on "Save and Continue"
        And I should see "We’re now ready to obtain your credit report in real time to verify your credit score and review your credit history. You won’t be charged for this service. Please authorize us by selecting the checkbox below."
      And I click "Income"
        Then I should see content as "Software Engineer"
        And I should see content as "$123,454.00"
      And I should see "Documents"

  @javascript
  Scenario: update income with years of employer is less than 2
    When I am at loan management page
      And I should see "Income"
      And I click "Income"
      Then I clear value in "Job Title"
        And I fill in "Job Title" with "Software Engineer"
      Then I clear value in "Years At This Employer"
        And I fill in "Years At This Employer" with "1"
      Then I should see "Name Of Previous Employer"
        And I fill in "previous_employer_name" with "Eximbank"
        And I should see "Monthly Income"
          Then I fill in "previous_monthly_income" with "$3,333.00"
        And I should see "Job Title"
          Then I fill in "previous_job_title" with "CEO"
        And I should see "Years At This Employer"
          Then I fill in "previous_duration" with "12"
      Then I clear value in "Base Income"
        And I fill in "Base Income" with "$123,454.00"
        And I select "Monthly" from "Income Frequency"
      Then I click on "Save and Continue"
        And I should see "We’re now ready to obtain your credit report in real time to verify your credit score and review your credit history. You won’t be charged for this service. Please authorize us by selecting the checkbox below."
      And I click "Income"
        Then I should see content as "Software Engineer"
          And I should see "Name Of Previous Employer"
          And I should see content as "Eximbank"
          And I should see content as "$3,333.00"
          And I should see content as "CEO"
          And I should see content as "12"
      And I should see "Documents"

  @javascript
  Scenario: update co-borrower's income
    When I am at loan management page which has co-borrower
      And I click "Borrower" in the "#tabBorrower"
      Then I select "With a co-borrower" from "I am applying"
        And I should see "Please provide information about your co-borrower"
        And I wait for 1 seconds
        And I click on "Save and Continue"
        And I should see "Name Of Current Employer"
      Then I click "Income"
        And I should see "Please provide income information of your co-borrower"
      Then I clear value in "current_salary"
        And I fill in "current_salary" with "$33,333.00"
        And I select "Monthly" from "pay_frequency"
      Then I clear value in "secondary_current_employer_name"
        And I fill in "secondary_current_employer_name" with "VCB"
      Then I clear value in "secondary_current_job_title"
        And I fill in "secondary_current_job_title" with "Business Analyst"
      Then I clear value in "secondary_current_duration"
        And I fill in "secondary_current_duration" with "5"
      Then I clear value in "secondary_current_salary"
        And I fill in "secondary_current_salary" with "$9,999.00"
      Then I select "Weekly" from "secondary_pay_frequency"
        And I click on "Save and Continue"
        And I should see "We’re now ready to obtain your credit report in real time to verify your credit score and review your credit history. You won’t be charged for this service. Please authorize us by selecting the checkbox below."
      Then I click "Income"
        And I should see content as "VCB"
        And I should see content as "Business Analyst"
        And I should see content as "$9,999.00"
