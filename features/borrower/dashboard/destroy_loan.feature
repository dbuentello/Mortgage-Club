Feature: DestroyLoan
  @javascript
  Scenario: destroy a loan at loans page
    When I am at my loans page
      Then I click on the element "#newLoanBtn"
      And I click on the element "#loanBtn"
    #  And I should see "Unknown Address"
    #  And I hover on first klass ".hover-img"
    #  And I wait for 3 seconds
    #Then I click on the first element ".trash-bd"
    #  And I wait for 3 seconds
    #  And At first klass ".modal-dialog" I click button "Yes"
    #  And I wait for 3 seconds
    #  And I should not see "Unknown Address"
