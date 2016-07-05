Feature: UpdateEmployerInfo
  @javascript @vcr-full-contact-api
  Scenario: fill in employer name with autocomplete
    When I am at loan management page
      And I should see "Income"
      And I click "Income"
    Then I clear value in "Name Of Current Employer"
      And I fill in "Name Of Current Employer" with "VietNam"
      And I should see "VietNamNet"
      And I click on "VietNamNet"
      And I wait for 4 seconds
      And I click on "Save and Continue"
    Then I click "Income"
      And I should see "VietNamNet"
