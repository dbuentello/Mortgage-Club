Feature: PropertyTabAtNewLoanPage
  @javascript
  Scenario: user submits a new property
    When I am at loan management page
      And I should see "Property"
      Then I click link with div "#tabProperty a"
        And I select "Vacation Home" from "Property Will Be"
        And I clear value in "Estimated Rental Income"
          Then I fill in "Estimated Rental Income" with "1111"
        And I choose "true_purpose"
        And I clear value in "Purchase Price"
          Then I fill in "Purchase Price" with "12345"
        Then I click on "Save and Continue"
        And I should see "I am applying"
      When I click link with div "#tabProperty a"
        And I should see "Vacation Home"
        And I should see "Purchase"
        And the "Purchase Price" field should contain "$12,345.00"
        And the "Estimated Rental Income" field should contain "$1,111.00"