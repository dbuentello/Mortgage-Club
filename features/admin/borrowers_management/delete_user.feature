Feature: DeleteUser
  @javascript
  Scenario: delete an user
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I wait for 30 seconds
      And a GET request is sent to "/auth/login/"
        And I wait for 30 seconds
        Then I fill in "Username" with "admin@man.net"
        Then I fill in "Password" with "secretpass"
        Then I click on the element "#login-form-submit"
        And I wait for 30 seconds
      Then I should see "Admin"
        And I click "Admin"
        And I should see "Borrowers"
      Then I click "Borrowers"
        And I should see "Remove"
        And I click on "Remove"
        And I press "Yes" in the modal "removeBorrower"
        And I should not see "Remove"
