Feature: DestroyLoan
  @javascript
  Scenario: destroy a loan
    When I am at dashboard page
      And I click on "Delete"
      And I press "Yes" in the modal "deleteLoan"
      And I should see "Property Address"
      And I should not see "Delete"

  @javascript
  Scenario: destroy a loan at loans page
    When I am at my loans page
      And I hover on ".hover-img"
      And I wait for 2 seconds
    Then I click link with div ".delete-btn"
      And I press "Yes" in the modal "deleteLoan"
      And I should see "Property Address"
