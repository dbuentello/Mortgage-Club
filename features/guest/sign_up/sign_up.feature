@ignore
Feature: SignUp
  @javascript
  Scenario: sign up
    When I go to the new user registration page
    And I turn off delayed jobs
    And I fill in "First Name" with "Cuong"
    And I fill in "Last Name" with "Vu"
    And I fill in "Email" with "user@gmail.com"
    And I fill in "login-form-password" with "Beatlendinghome"
    And I fill in "login-form-confirm-password" with "Beatlendinghome"
    Then I press "login-form-submit"
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
