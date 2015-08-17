Feature: Edit Loan Page
  @javascript
  Scenario: User uploads borrower's document
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
    And there is a property with the purchase price "1000000" and with the usage "0"
    And there is a closing with the name "Fake Name"
    And there is a loan with the id "1" and with the amount "500000" and with the num of months "24" and with the purpose "0" and with the property above and with the closing above
    And I login as "testing@man.net" with password "secretpass"
    Given I am on the edit loan page of "1"
      And I click "Income"
      And I should see "W2 - Most recent tax year"
