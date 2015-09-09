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
    Then I fill in "Email" with "cuongvu0103@gmail.com"
      And I fill in "First Name" with "Cuong"
      And I fill in "Last Name" with "Vu"
      And I fill in "Phone number" with "8889998"
      And I fill in "Skype" with "keeping_fit"
      And I attach the file "spec/files/avatar.png" to the hidden "loan_member[avatar]"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Avatar    | Name     | Email                  | Phone number | Skype        |
      | *         | *        | *                      | *            | *            |
      | *         | Cuong Vu | cuongvu0103@gmail.com  | 8889998      | keeping_fit  |
    Then an email should have been sent with:
      """
      From: billy@mortgageclub.io
      To: cuongvu0103@gmail.com
      Subject: Confirmation instructions
      """
      And "cuongvu0103@gmail.com" should receive an email
      And I open the email
      And I follow "Confirm my account" in the email
    Then I should see "Your email address has been successfully confirmed."

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
      And I fill in "Skype" with "keeping_fit"
      And I attach the file "spec/files/avatar.png" to the hidden "loan_member[avatar]"
      And I choose "false_sendConfirmation"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Avatar    | Name     | Email                  | Phone number | Skype        |
      | *         | *        | *                      | *            | *            |
      | *         | Cuong Vu | cuongvu0103@gmail.com  | 8889998      | keeping_fit  |
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
      And I fill in "Skype" with "keeping_fit"
    Then I click on "Submit"
      And the "First Name" field should contain "Cuong"
      And the "Last Name" field should contain "Vu"
      And the "Phone number" field should contain "8889998"
      And the "Skype" field should contain "keeping_fit"

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
