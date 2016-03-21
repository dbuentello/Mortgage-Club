Feature: SwitchBorrower
  @javascript
  Scenario: switch to user
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
      Then I should see "Admin"
        And I click "Admin"
        And I should see "Borrowers"
      Then I click "Borrowers"
        And I should see "Switch to borrower"
        And I click on "Switch to borrower"
        And I should see "new loan"