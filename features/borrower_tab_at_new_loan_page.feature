Feature: BorrowerTabAtNewLoanPage
  @javascript
  Scenario: user submits a new borrower
    When I am at loan management page
      And I click on "Borrower"
      Then I select "As an individual" from "I am applying"
      Then I clear value in "First Name"
        And I fill in "First Name" with "Cuong"
      Then I clear value in "Middle Name"
        And I fill in "Middle Name" with "Manh"
      Then I clear value in "Last Name"
        And I fill in "Last Name" with "Vu"
      Then I clear value in "Social Security Number"
        And I fill in "Social Security Number" with "222222222"
      Then I clear value in "Years in School"
        And I fill in "Years in School" with "12"
      Then I clear value in "Your Current Address"
        When I fill in "Your Current Address" with "sanf"
          And I click on "San Francisco"
      And I fill in "Date of Birth" with "03/01/1991"
      Then I click on "Save and Continue"
        And I wait for 1 seconds
      Then I should see "W2 - Most recent tax year"
      When I click on "Borrower"
        And I should see "As an individual"
        And the "First Name" field should contain "Cuong"
        And the "Middle Name" field should contain "Manh"
        And the "Last Name" field should contain "Vu"
        And the "Date of Birth" field should contain "03/01/1991"
      When I select "With a co-borrower" from "I am applying"
        And I should see "Please provide information about your co-borrower"
        And I fill in "secondary_borrower_first_name" with "Mark"
        And I fill in "secondary_borrower_last_name" with "Vu"
        And I fill in "secondary_borrower_dob" with "01/01/1991"
        And I fill in "secondary_borrower_email" with "co-borrower@gmail.com"
        Then I click on "Save and Continue"
          And I wait for 1 seconds
        Then I should see "W2 - Most recent tax year"
        When I click on "Borrower"
          And I should see "With a co-borrower"
          And the "secondary_borrower_first_name" field should contain "Mark"
          And the "secondary_borrower_last_name" field should contain "Vu"
          And the "secondary_borrower_dob" field should contain "01/01/1991"
          And the "secondary_borrower_email" field should contain "co-borrower@gmail.com"
