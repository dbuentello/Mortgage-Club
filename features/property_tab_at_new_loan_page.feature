Feature: PropertyTabAtNewLoanPage
  @javascript
  Scenario: user submits a new property
    When I am at loan management page
      And I should see "Property"
      Then I click "Property"
        And I select "Vacation Home" from "Property Will Be"
        And I clear value in "Estimated Rental Income"
          Then I fill in "Estimated Rental Income" with "$1,111.00"
        And I choose "true_purpose"
        And I clear value in "Purchase Price"
          Then I fill in "Purchase Price" with "$12,345.00"
        And I clear value in "Down Payment"
          Then I fill in "Down Payment" with "$1,345.00"
          And I wait for 2000 seconds
        Then I click on "Save and Continue"
        And I should see "I am applying"
      When I click "Property"
        And I should see "Vacation Home"
        And I should see "Purchase"
        And the "Down Payment" field should contain "$1,345.00"
        And the "Purchase Price" field should not contain ""
        And the "Estimated Rental Income" field should not contain ""
