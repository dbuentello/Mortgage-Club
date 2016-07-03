Feature: AddProperty
  @javascript
  Scenario: add a property
    When I am at loan management page
      And I should see "Property"
      Then I click "Property"
        And I clear value in "Property Address"
      Then I fill in "Property Address" with "1920 South Las Vegas Boulevard, Las Vegas"
      And I wait for 2 seconds
        And I select "Vacation Home" from "Property Will Be"
        And I clear value in "Estimated Rental Income"
          Then I fill in "Estimated Rental Income" with "$1,111.00"
        And I choose "true_purpose"
        And I clear value in "Purchase Price"
          Then I fill in "Purchase Price" with "$12,345.00"
        And I clear value in "Down Payment"
          Then I fill in "Down Payment" with "$1,345.00"
        Then I click on "Save and Continue"
        And I should see "I am applying"
      When I click "Property"
        And I should see "Vacation Home"
        And I should see "Purchase"
        And the "Down Payment" field should contain "$1,345.00"
        And the "Purchase Price" field should not contain ""
        And the "Estimated Rental Income" field should not contain ""
      Then I clear value in "Property Address"
      Then I fill in "Property Address" with "1920 South Las Vegas Boulevard, Las Vegas"
      And I wait for 2 seconds
        And I select "Primary Residence" from "Property Will Be"
        And I choose "false_purpose"
        And I clear value in "Original Purchase Price"
        Then I fill in "Original Purchase Price" with "$52,345.00"
        And I wait for 2 second
        And I clear value in "Purchase Year"
        Then I fill in "Purchase Year" with "1996"
        Then I clear value in "Estimated Mortgage Balance"
        And I fill in "Estimated Mortgage Balance" with "$123,000.00"
        Then I click on "Save and Continue"
        And I wait for 2 seconds
      And I should see "Borrower"
      Then I click on "Borrower"
        And I should see "I am applying"
        And the "first_borrower_current_address" field should contain "1920 North Las Vegas Boulevard, North Las Vegas, NV 89030"
        And the "first_borrower_years_in_current_address" field should contain "21"
        And the radio with id "true_first_borrower_currently_own" to be disabled
