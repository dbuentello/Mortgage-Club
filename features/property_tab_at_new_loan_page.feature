Feature: PropertyTabAtNewLoanPage
  @javascript
  Scenario: user submits a new property
    When I am at loan management page
      And I should see "Property"
      Then I click link with div "#tabProperty a"
        And I clear value in "Property Address"
      Then I fill in "Property Address" with "1920 South Las Vegas Boulevard, Las Vegas"
      And I wait for 1 seconds
        And I select "Vacation Home" from "Property Will Be"
        And I clear value in "Estimated Rental Income"
          Then I fill in "Estimated Rental Income" with "$1,111.00"
        And I choose "true_purpose"
        And I clear value in "Purchase Price"
          Then I fill in "Purchase Price" with "$12,345.00"
        Then I click on "Save and Continue"
        And I should see "I am applying"
      When I click link with div "#tabProperty a"
        And I should see "Vacation Home"
        And I should see "Purchase"
        And the "Purchase Price" field should not contain ""
        And the "Estimated Rental Income" field should not contain ""
