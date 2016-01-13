Feature: LoanActivityTypeManagements
  @javascript
  Scenario: add new activity_type
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan Activity Types"
    Then I click "Loan Activity Types"
      And I should see "Activity Type Managements"
      And I should see "Add new Activity Type"
    Then I fill in "Label" with "label"
      And I fill in "type_name" with "name 1"
    Then I click on "+" in the "#addTypeNameMapping"
      And I fill in "type_name" with "name 2"
    Then I click on "+" in the "#addTypeNameMapping"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Label | *       |
      | label | *       |

  @javascript
  Scenario: remove a activity_type
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a activity type
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan Activity Types"
    Then I click "Loan Activity Types"
      And I should see "Activity Type Managements"
      And I should see "Edit"
      And I click on "Edit"
    Then I fill in "Label" with "new label"
      And I fill in "type_name" with "name 1"
    Then I click on "+" in the "#addTypeNameMapping"
      And I fill in "type_name" with "name 2"
    Then I click on "+" in the "#addTypeNameMapping"
    Then I click on "Submit"
      And the "Label" field should contain "new label"

  @javascript
  Scenario: remove a activity_type
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a activity type
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Loan Activity Types"
    Then I click "Loan Activity Types"
      And I should see "Activity Type Managements"
      And I should see "Edit"
      And I click on "Edit"
    Then I click on "Remove"
      And I press "Yes" in the modal "removeActivityType"
    Then I should be on the loan activity type managements page
