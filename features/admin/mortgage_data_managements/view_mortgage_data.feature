Feature: ViewMortgageData
  @javascript
  Scenario: view a mortgage data record
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And there is a mortgage data with the property address "5679 Cochran St, Simi Valey"
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Mortgage Data"
    Then I click "Mortgage Data"
      And I should see "More..."
      And I click on "More"
    Then I should see "Original Loan Information"
    Then I should see "Back"
    And I click on "Back"
    And I should see "Search"
    Then I fill the input has id "#search_value" with "5679 Cochran"
    And I click on "Search"
    Then I should see "5679 Cochran St, Simi Valey"
