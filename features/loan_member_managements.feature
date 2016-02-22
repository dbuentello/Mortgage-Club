Feature: LoanMemberManagements
  @javascript
  Scenario: add new member and with confirmation email
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan Members"
    Then I click "Loan Members"
      And I should see "Loan Members"
      And I should see "Add new member"
    And I turn off delayed jobs
    Then I fill in "Email" with "cuongvu0103@gmail.com"
      And I fill in "First Name" with "Cuong"
      And I fill in "Last Name" with "Vu"
      And I fill in "Phone number" with "8889998"
      And I attach the file "spec/files/avatar.png" to the hidden "loan_member[avatar]"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Avatar    | Name     | Email                  | Phone number |
      | *         | *        | *                      | *            |
      | *         | Cuong Vu | cuongvu0103@gmail.com  | 8889998      |
    Then an email should have been sent with:
      """
      From: hello@mortgageclub.co
      To: cuongvu0103@gmail.com
      Subject: Welcome to MortgageClub
      """
      And "cuongvu0103@gmail.com" should receive an email
      Then I open the email
        And I should see "Thanks for signing up" in the email body
    Then I turn on delayed jobs

  @javascript
  Scenario: add new member and without confirmation email
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan Members"
    Then I click "Loan Members"
      And I should see "Loan Members"
      And I should see "Add new member"
    Then I fill in "Email" with "cuongvu0103@gmail.com"
      And I fill in "First Name" with "Cuong"
      And I fill in "Last Name" with "Vu"
      And I fill in "Phone number" with "8889998"
      And I attach the file "spec/files/avatar.png" to the hidden "loan_member[avatar]"
      And I choose "false_sendConfirmation"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Avatar    | Name     | Email                  | Phone number |
      | *         | *        | *                      | *            |
      | *         | Cuong Vu | cuongvu0103@gmail.com  | 8889998      |
    Then no email should have been sent
      And "cuongvu0103@gmail.com" should receive no email

  @javascript
  Scenario: edit a member
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan Members"
    Then I click "Loan Members"
      And I should see "Loan Members"
      And I should see "Edit"
      And I click on "Edit"
    Then I fill in "First Name" with "Cuong"
      And I fill in "Last Name" with "Vu"
      And I fill in "Phone number" with "8889998"
    Then I click on "Submit"
      And the "First Name" field should contain "Cuong"
      And the "Last Name" field should contain "Vu"
      And the "Phone number" field should contain "8889998"

  @javascript
  Scenario: remove a member
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan Members"
    Then I click "Loan Members"
      And I should see "Loan Members"
      And I should see "Edit"
      And I click on "Edit"
    Then I click on "Remove"
      And I press "Yes" in the modal "removeUser"
    Then I should be on the loan member managements page
