Feature: HomepageRateManagements
  @javascript
  Scenario: edit a homepage rate
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a homepage rate
      And there is a loans members association
    When I mock S3 object for all files
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Homepage Rates"
     Then I click "Homepage Rates"
      And I should see "Homepage Rates"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I fill in "Lender Name" with "Mortgage Club"
      And I fill in "Program" with "15 Year Fixed"
      And I fill in "Rate Value" with "0.025"
    Then I click on "Save"
      And I should see "Mortgage Club"
      And I should see "15 Year Fixed"
      And I should see "0.025"