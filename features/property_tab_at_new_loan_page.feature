Feature: PropertyTabAtNewLoanPage
  @javascript
  Scenario: user submits a new property
    When I am at loan management page
      Then I click on "Property"
        And I clear value in "Property Address"
          Then I fill in "Property Address" with "sanf"
            And I click on "San Francisco"
        Then I select "Duplex" from "Property Type"
        And I select "Vacation Home" from "Property Will Be"
        And I select "Purchase" from "Purpose of Loan"
        And I clear value in "Purchase Price"
          Then I fill in "Purchase Price" with "12345"
        Then I click on "Save and Continue"
        And I wait for 1 seconds
        And I should see "I am applying"
      When I click on "Property"
        Then I should see "Duplex"
        And I should see "Vacation Home"
        And I should see "Purchase"
        And the "Purchase Price" field should contain "$12,345"
