Feature: PropertyTabAtNewLoanPage
  @javascript
  Scenario: user submits a new property
    When I am at loan management page
      And I should see "Property"
      Then I click link with div "#tabProperty a"
        And I clear value in "Property Address"
        And I fill in "Property Address" with "1921 South Las Vegas Boulevard, Las Vegas, NV 89104"
        And I select "Vacation Home" from "Property Will Be"
        And I choose "true_purpose"
        And I clear value in "Purchase Price"
          Then I fill in "Purchase Price" with "12345"
        Then I click on "Save and Continue"
        And I should see "I am applying"
      When I click link with div "#tabProperty a"
        And I wait for 2 seconds
        And I should see "Vacation Home"
        And I should see "Purchase"
        And the "Purchase Price" field should contain "$12,345"