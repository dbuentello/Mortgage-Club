Feature: User
  Scenario: updates avatar at profile page
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the token "1"
      And I login as "testing@man.net" with password "secretpass"
    When I go to the edit user registration page
      And I attach the file "spec/files/avatar.png" to "user[avatar]"
      And I press "Change"
    Then I should see the avatar "avatar.png"

  @javascript
  Scenario: updates password at profile page
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And I login as "testing@man.net" with password "secretpass"
    When I go to the edit user registration page
      And I attach the file "spec/files/avatar.png" to "user[avatar]"
      And I change password as "12345678" with current password "secretpass"
      And I press "Change"
      Then I should not see the avatar "avatar.png"

  @javascript
  Scenario: logins as loan_member role
    Given there is a loan_member_user_with_loan_member with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the token "1"
      And I login as "testing@man.net" with password "secretpass"
    Then I should see "Loans list"

  @javascript
  Scenario: signs up
    When I go to the new user registration page
    And I turn off delayed jobs
    And I fill in "First name" with "Cuong"
    And I fill in "Last name" with "Vu"
    And I fill in "Email" with "user@gmail.com"
    And I fill in "Password" with "Beatlendinghome"
    And I fill in "Password Confirmation" with "Beatlendinghome"
    Then I press "sign up"
    Then I should see "Property Address"
    And an email should have been sent with:
      """
      From: hello@mortgageclub.co
      To: user@gmail.com
      Subject: Welcome to MortgageClub
      """
    And "user@gmail.com" should receive an email
    Then I open the email
      And I should see "Welcome to MortgageClub!" in the email body
    Then I turn on delayed jobs