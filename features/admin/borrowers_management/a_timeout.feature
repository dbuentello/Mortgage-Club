Feature: DeleteUser
  @javascript
  Scenario: delete an user
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I wait for 60 seconds
