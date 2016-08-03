Feature: RemoveHomepageFaqType
  @javascript
  Scenario: remove a homepage faq type
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a homepage faq type with the name "Name"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Question Types"
    Then I click "Question Types"
      And I should see "Question Type - Managements"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I click on "Remove" in the ".btn-danger"
      And I press "Yes" in the modal "removeQuestionType"
    Then I should be on the homepage faq types page
