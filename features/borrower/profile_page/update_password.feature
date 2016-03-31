Feature: UpdatePassword
  @javascript
  Scenario: update password
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And I login as "testing@man.net" with password "secretpass"
    When I go to the edit user registration page
      And I fill in "user[first_name]" with "Cuong Vu"
      And I fill in "user[password]" with "12345678"
      And I fill in "user[password_confirmation]" with "12345678"
      And I fill in "user[current_password]" with "secretpass"
      And I press "Update"
      And I wait for 1 seconds
      And I reload the page
      Then I should see "Cuong Vu"
