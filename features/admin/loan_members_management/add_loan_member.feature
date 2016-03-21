Feature: AddLoanMember
  @javascript
  Scenario: add a loan member
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
      And I fill in "Phone Number" with "8889998"
      And I fill in "Individual NMLS" with "124566"
      And I fill in "Company Name" with "Green Apple"
      And I fill in "Company Address" with "2346 Hope Avenue Wall Street"
      And I fill in "Company Phone Number" with "(234)888-9998"
      And I fill in "Company NMLS" with "234311"
      And I fill in "Default Password" with "this-is-a-password"
      And I attach the file "spec/files/avatar.png" to the hidden "loan_member[avatar]"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Avatar    | Name     | Email                  | Phone Number |
      | *         | *        | *                      | *            |
      | *         | Cuong Vu | cuongvu0103@gmail.com  | 8889998      |
    Then no email should have been sent
      And "cuongvu0103@gmail.com" should receive no email
    Then I click "Admin"
      And I should see "Log Out"
      And I click "Log Out"
      And I should see "100% Online. Lowest Rate Guaranteed."
      And I login as "cuongvu0103@gmail.com" with password "this-is-a-password"
      And I should see "Loans list"
