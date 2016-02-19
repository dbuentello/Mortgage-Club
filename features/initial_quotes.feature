Feature: InitialQuotes
  @javascript @vcr
  Scenario: fill in form and see rates
  When I go to the quotes page
    And I should see "Initial Quotes"
  Then I fill in "ZIP code" with "95127"
    And I fill in "Property value" with "400000"
    And I fill in "Credit score" with "750"
    And I select "Purchase" from "Mortgage purpose"
    And I select "Primary Residence" from "Property will be"
    And I select "Single Family Home" from "Property type"
    And I press "Get rates"
    And I should see "Sort by"
  Then At first klass ".board-header" I click link "Select"
    And I should see "sign up"

  @javascript @vcr
  Scenario: select help me choose
  When I go to the quotes page
    And I should see "Initial Quotes"
  Then I fill in "ZIP code" with "95127"
    And I fill in "Property value" with "400000"
    And I fill in "Credit score" with "750"
    And I select "Purchase" from "Mortgage purpose"
    And I select "Primary Residence" from "Property will be"
    And I select "Single Family Home" from "Property type"
    And I press "Get rates"
    And I should see "help me choose"
    And I scroll up to the top
  Then I click on "help me choose"
    And I should see "Your Best Option"
  Then At first klass ".best-rate" I click link "Select"
    And I should see "sign up"
