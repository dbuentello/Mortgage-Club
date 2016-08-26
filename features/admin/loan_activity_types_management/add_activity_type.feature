Feature: AddActivityType
  @javascript
  Scenario: add an activity type
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan Activity Types"
    Then I click "Loan Activity Types"
      And I should see "Loan Activity Type - Managements"
      And I should see "Add new Activity Type"
    Then I fill in "Activity Type" with "label"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Activity Type | *       |
      | label | *       |
