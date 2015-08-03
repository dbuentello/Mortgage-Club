Feature: Dashboard
  Scenario: display borrower's address and loan's title
    Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a borrower with the first name "Cuong" and the last name "Vu" with the user above
      And there is a loan with the amortization type "USDA" with the user above
      And there is a borrower address with the is current "true" with the borrower above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" with the borrower address above
      And I login as "testing@man.net"
      And show me the page
    Then I follow "/dashboard"
      And I should see "81458 Borer Falls, Apt. 305, West Emiltown, Virginia, 9999"
