Feature: LoanMemberManagements
  @javascript
  Scenario: add new member
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
      | Avatar    | Name     | Email                  | Phone number | Skype        | Role          |
      | *         | *        | *                      | *            | *            | loan_member   |
      | *         | Cuong Vu | cuongvu0103@gmail.com  | 8889998      | keeping_fit  | loan_member   |

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
      And I wait for 1 seconds
      And the "First Name" field should contain "Cuong"
      And the "Last Name" field should contain "Vu"
      And the "Phone number" field should contain "8889998"
      And the "Skype" field should contain "keeping_fit"
