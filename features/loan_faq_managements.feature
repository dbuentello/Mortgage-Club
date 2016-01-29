Feature: LoanFaqManagements
  @javascript
  Scenario: add new faq
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan FAQs"
    Then I click "Loan FAQs"
      And I should see "FAQ Managements"
      And I should see "Add new FAQ"
    Then I fill in "Question" with "Question"
      And I set the value "<p>There is an answer</p>" to the hidden "faq[answer]"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Question | *       |
      | Question | *       |

  @javascript
  Scenario: edit a faq
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a faq with the question "Question" and with the answer "<p>Answer</p>"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan FAQs"
     Then I click "Loan FAQs"
      And I should see "FAQ Managements"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I fill in "Question" with "New Question"
      And I set the value "<p>There is a new answer</p>" to the hidden "faq[answer]"
    Then I click on "Submit"
      And the "Question" field should contain "New Question"

  @javascript
  Scenario: remove a faq
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a faq with the question "Question" and with the answer "<p>Answer</p>"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan FAQs"
     Then I click "Loan FAQs"
      And I should see "FAQ Managements"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I click on "Remove" in the ".btn-danger"
      And I press "Yes" in the modal "removeFaq"
    Then I should be on the loan faq managements page
