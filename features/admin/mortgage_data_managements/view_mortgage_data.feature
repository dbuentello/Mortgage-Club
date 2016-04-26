Feature: ViewMortgageData
  @javascript
  Scenario: view a loan member
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And there is a mortgage data
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Mortgage Data"
    Then I click "Mortgage Data"
      And I should see "Loan Members"
      And I should see "More..."
      And I click on "More"
    Then I should see "Original Loan Information"
    Then I should see "Back"
    And I click on "Back"
    And I should see "Search"
