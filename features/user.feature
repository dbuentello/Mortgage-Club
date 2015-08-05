Feature: User
  Scenario: updates avatar at profile page
    Given there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the token "1"
      And I login as "testing@man.net"
    When I go to the edit user registration page
      And I attach the file "spec/files/avatar.png" to "user[avatar]"
      And I press "Update"
    Then I should see the avatar "avatar.png"
