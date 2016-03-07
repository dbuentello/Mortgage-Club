Feature: SettingManagements
  @javascript
  Scenario: change ocr on off
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a setting
      And there is a loans members association
    When I mock S3 object for all files
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Settings"
     Then I click "Settings"
      And I should see "Enable OCR"
      And I should see "Disable"
    Then I click on "Disable"
      And I should see "Enable"
