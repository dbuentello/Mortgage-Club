Feature: PropertyTabAtNewLoanPage
  @javascript
  Scenario: user submits a new property
    When I am at loan management page
      And I should see "Property"
      Then I click "Property"
        And I clear value in "Property Address"
      Then I fill in "Property Address" with "1920 South Las Vegas Boulevard, Las Vegas"
      And I wait for 1 seconds
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
        And the "Purchase Price" field should contain "$12,345.00"
        And the "Down Payment" field should contain "$1,345.00"
        And the "Estimated Rental Income" field should contain "$1,111.00"
