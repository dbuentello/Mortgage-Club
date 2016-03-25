Feature: EditFaq
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
      And I should see "FAQ - Management"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I fill in "Question" with "New Question"
      And I set the value "<p>There is a new answer</p>" to the hidden "faq[answer]"
    Then I click on "Submit"
      And the "Question" field should contain "New Question"
