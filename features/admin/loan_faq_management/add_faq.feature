Feature: AddFaq
  @javascript
  Scenario: add a faq
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan FAQs"
    Then I click "Loan FAQs"
      And I should see "FAQ - Management"
      And I should see "Add new FAQ"
    Then I fill in "Question" with "Question"
      And I set the value "<p>There is an answer</p>" to the hidden "faq[answer]"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Question | *       |
      | Question | *       |
