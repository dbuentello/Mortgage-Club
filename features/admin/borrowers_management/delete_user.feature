Feature: DeleteUser
  @javascript
  Scenario: delete an user
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a user with the first name "Borrower" and with the email "borrower@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a borrower with the user above
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
      Then I should see "Admin"
        And I click "Admin"
        And I should see "Borrowers"
      Then I click "Borrowers"
        And I should see "Remove"
        And I click on "Remove"
        And I press "Yes" in the modal "removeBorrower"
        And I should not see "Remove"
        Then I click "Admin"
        And I should see "Log Out"
        And I click "Log Out"
        And I should see "100% Online. Lowest Rate Guaranteed."
        And I login as "borrower@man.net" with password "secretpass"
        Then I should see "Invalid email or password."
