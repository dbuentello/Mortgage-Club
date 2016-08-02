Feature: EditHomepageFaqType
  @javascript
  Scenario: edit a homepage faq type
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a homepage faq type with the name "name"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Question Types"
    Then I click "Question Types"
      And I should see "Question Type - Managements"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I fill in "Name" with "New Name"
    Then I click on "Submit"
      And the "Name" field should contain "New Name"
