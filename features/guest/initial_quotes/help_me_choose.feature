Feature: HelpMeChoose
  @javascript @vcr
  Scenario: select "Help me choose"
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
    And I should see "help me choose"
    And I scroll up to the top
  Then I click on the element "#helpmechoose-md"
    And I should see "Your Best Option"
  Then At first klass ".best-rate" I click link "Select"
    And I should see "Register now"
