Feature: AddHomepageFaqType
  @javascript
  Scenario: add a homepage faq type
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Question Types"
    Then I click "Question Types"
      And I should see "Question Type - Managements"
      And I should see "Add new Question Type"
    Then I fill in "Name" with "Name"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Name | *       |
      | Name | *       |
