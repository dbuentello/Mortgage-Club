Feature: RefinanceAlert
  @javascript @vcr
  Scenario: fill in form and see thanks you
  When I go to the refinance alert page
    And I should see "FREE REFINANCE ALERT"
    And I should see "Upload your mortgage statement"
  Then I fill in "email" with "james.nguyen.vnn@gmail.com"
    And I fill in "phone_number" with "0989691092"
    And I attach the file "spec/files/sample.pdf" to the hidden "potential_user[mortgage_statement]"
    And I should see "sample.pdf" within ".fileName"
    And I click on "Text message"
  Then I click "SET MY ALERT"
