@ignore
Feature: SelectRate
  @javascript @vcr-select-rates
  Scenario: select rate with completed loan
    When I am at select rates page
      And I check on checkbox "#30years"
      And I should not see "15 year fixed" inside any ".mortgagePrograms"
      And I should not see "5/1 ARM" inside any ".mortgagePrograms"
      And I uncheck on checkbox "#30years"
      And I check on checkbox "#15years"
      And I should not see "30 year fixed" inside any ".mortgagePrograms"
      And I should not see "5/1 ARM" inside any ".mortgagePrograms"
      And I uncheck on checkbox "#15years"
      And I check on checkbox "#51arm"
      And I should not see "30 year fixed" inside any ".mortgagePrograms"
      And I should not see "15 year fixed" inside any ".mortgagePrograms"
      And I uncheck on checkbox "#51arm"
      And I check on checkbox "#30years"
      And I check on checkbox "#15years"
      And I should not see "5/1 ARM" inside any ".mortgagePrograms"
      And I click link with div ".choose-btn"
      And I should see "NMLS"
      And I should see "Your Best Option"
      And I click on "Back"
      And I should see "Sort by"
      And I click on a first ".select-btn"
      And I should see "Hang tight, we're generating disclosure forms for you to sign!"
