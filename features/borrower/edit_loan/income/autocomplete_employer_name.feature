Feature: AutocompleteEmployerName
  @javascript
  Scenario: autocomplete employer name
    When I am at loan management page
      And I should see "Income"
      And I click "Income"
    Then I clear value in "Name Of Current Employer"
      And I fill in "Name Of Current Employer" with "tech in"
      And I should see "Tech in Asia"
      And I click on "Tech in Asia"
      And I click on "Save and Continue"
    Then I click "Income"
      And I should see "Tech in Asia"
