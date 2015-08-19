Feature: Dashboard
  @javascript
  Scenario: destroy a loan
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a property with the purchase price "1000000" and with the usage "0"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the property above
      And I login as "testing@man.net" with password "secretpass"
    Then I follow "Dashboard"
      And I click on "Delete Loan"
      And I click on "Yes"
    Then I should be on the my loans page

  @javascript
  Scenario: display borrower's address and loan's title
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a property with the purchase price "1000000" and with the usage "0"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the property above and with the closing above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" with the property above
      And I login as "testing@man.net" with password "secretpass"
    Then I follow "Dashboard"
      And I should see content as "81458 Borer Falls, Apt. 305, West Emiltown, Virginia, 9999"
      And I should see content as "$500,000k 2-year fixed 50% LTV Primary Residence Purchase Loan"

  @javascript
  Scenario: edit a loan
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a property with the purchase price "1000000" and with the usage "0"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the property above
      And I login as "testing@man.net" with password "secretpass"
    Then I follow "Dashboard"
      And I click on "Edit Loan"
    Then I should see "Real Estates"
      And I should see "ESigning"
