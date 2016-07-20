Feature: RemoveActivityType
  @javascript
  Scenario: remove an activity type
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a activity type
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan Activity Types"
    Then I click "Loan Activity Types"
      And I should see "Loan Activity Type - Managements"
      And I should see "Edit"
      And I click on "#edit_activity_type"
    Then I click on "Remove"
      And I press "Yes" in the modal "removeActivityType"
    Then I should be on the loan activity type managements page
