Feature: DestroyLoan
  @javascript
  Scenario: destroy a loan at loans page
    When I am at my loans page
      And I hover on ".hover-img"
      And I wait for 3 seconds
    Then I click on the element ".trash-bd"
      And I wait for 3 seconds
      And I click on "Yes"
      And I wait for 3 seconds
      And I should see "Property Address"
