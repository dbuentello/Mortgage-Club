Feature: FillForm
  @javascript @vcr
  Scenario: fill in form with purchase loan
  When I go to the initial quotes page
    And I should see "Answer a few questions and get a customized rate quote in 10 seconds."
  Then I select "Purchase" from "Mortgage Purpose"
    And I should see "Down Payment"
    And I fill in "ZIP Code" with "95127"
    And I fill in "Property Value" with "500000"
    And I select "Primary Residence" from "Property Will Be"
    And I select "Single Family Home" from "Property Type"
    And I select "740+" from "Credit Score"
    And I press "find my rates"
    And I should see "Sort by"
    And I scroll up to the top
  Then At first klass ".board-header" I click link "Select"
    And I should see "sign up"

  @javascript @vcr
  Scenario: fill in form with refinance loan
  When I go to the initial quotes page
    And I should see "Answer a few questions and get a customized rate quote in 10 seconds."
  Then I select "Refinance" from "Mortgage Purpose"
    And I should see "Current Mortgage Balance"
    And I fill in "ZIP Code" with "95127"
    And I fill in "Property Value" with "500000"
    And I clear value in "Current Mortgage Balance"
      Then I fill in "Current Mortgage Balance" with "400000"
    And I select "Primary Residence" from "Property Will Be"
    And I select "Single Family Home" from "Property Type"
    And I select "740+" from "Credit Score"
    And I press "find my rates"
    And I should see "Sort by"
    And I scroll up to the top
  Then At first klass ".board-header" I click link "Select"
    And I should see "sign up"