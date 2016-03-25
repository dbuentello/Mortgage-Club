Feature: UpdatePassword
  @javascript
  Scenario: update password
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And I login as "testing@man.net" with password "secretpass"
    When I go to the edit user registration page
      And I attach the file "spec/files/avatar.png" to "user[avatar]"
      And I change password as "12345678" with current password "secretpass"
      And I press "Change"
      Then I should not see the avatar "avatar.png"
