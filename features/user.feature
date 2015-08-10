Feature: User
  Scenario: updates avatar at profile page
    Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the token "1"
      And I login as "testing@man.net" with password "secretpass"
    When I go to the edit user registration page
      And I attach the file "spec/files/avatar.png" to "user[avatar]"
      And I press "Update"
    Then I should see the avatar "avatar.png"

  @javascript
  Scenario: updates password at profile page
    Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And I login as "testing@man.net" with password "secretpass"
    When I go to the edit user registration page
      And I attach the file "spec/files/avatar.png" to "user[avatar]"
      And I change password as "12345678" with current password "secretpass"
      And I press "Change"
      Then I should not see the avatar "avatar.png"
      And I click "Log out"
      And I login as "testing@man.net" with password "12345678"
    Then I should be on the new loan page

  @javascript
  Scenario: logins as staff role
    Given there is a staff with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the token "1"
      And I login as "testing@man.net" with password "secretpass"
    Then I should see "Loans list"
