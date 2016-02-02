Feature: LoanPotentialUserManagements
  @javascript
  Scenario: edit a potential user
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a potential user
      And there is a loans members association
    When I mock S3 object for all files
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Potential Users"
     Then I click "Potential Users"
      And I should see "Potential User Managements"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I fill in "Email" with "newemail@gmail.com"
      And I fill in "Phone Number" with "(234) 567-8901"
    Then I click on "Submit"
      And the "Email" field should contain "newemail@gmail.com"
      And the "Phone Number" field should contain "(234) 567-8901"

  @javascript
  Scenario: remove a potential
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a potential user
      And there is a loans members association
    When I mock S3 object for all files
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Potential Users"
     Then I click "Potential Users"
      And I should see "Potential User Managements"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I click on "Remove" in the ".btn-danger"
      And I press "Yes" in the modal "removePotentialUser"
    Then I should be on the potential user managements page
