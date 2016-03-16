Feature: SelectRates
  @javascript
  Scenario: show rates with loan completed
    When I am at select rates page
      And I click link with div ".choose-btn"
      And I should see "NMLS"
      And I click on "Back"
      And I should see "Sort by"