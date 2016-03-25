Feature: AccessToUnnewLoan
  @javascript
  Scenario: accesses to loan dashboard page
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the status "pending" and with the user above and with the closing above
      And there is a loan_member_user_with_loan_member with the first name "Michael" and the last name "Gifford"
      And there is a property with the id "be69aefe-3946-4b85-9c54-58dd51306b1c" and with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with the loan above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" and the property id "be69aefe-3946-4b85-9c54-58dd51306b1c"

      And I login as "testing@man.net" with password "secretpass"
    Then I should see "Dashboard"
      And I should not see "Edit Application"
    Then I click "Dashboard"
      And I should see "81458 Borer Falls, Apt. 305, West Emiltown, Virginia 9999"
