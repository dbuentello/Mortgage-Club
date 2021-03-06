@ignore
Feature: UpdateAvatar
  @javascript
  Scenario: update avatar
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the token "1"
      And I login as "testing@man.net" with password "secretpass"
    When I go to the edit user registration page
      And I attach the file "spec/files/avatar.png" to the avatar file input "user[avatar]"
      And I press "Update"
    Then I should see the avatar "avatar.png"
