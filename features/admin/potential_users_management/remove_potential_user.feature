Feature: RemovePotentialUser
  @javascript
  Scenario: remove a potential user
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a potential user
      And there is a loans members association
    When I mock S3 object for all files
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Potential Users"
     Then I click "Potential Users"
      And I should see "Potential Users"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I click on "Remove" in the ".btn-danger"
      And I press "Yes" in the modal "removePotentialUser"
    Then I should be on the potential user managements page
