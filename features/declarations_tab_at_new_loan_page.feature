Feature: DeclarationsTabAtNewLoanPage
  @javascript
  Scenario: User submit a declaration at new loan page
    When I am at loan management page
      And I should see "Declarations"
      And I click on "Declarations"
      And I choose "true_outstanding_judgment"
      And I choose "false_co_maker_or_endorser"
      And I choose "false_us_citizen"
        Then I should see "Are you a permanent resident alien?"
        And I choose "true_permanent_resident_alien"
      And I choose "true_ownership_interest"
        Then I should see "(1) What type of property did you own?"
        And I should see "(2) How did you hold title to this property?"
        And I select "Secondary Resident" from "type_of_property"
        And I select "Other" from "title_of_property"
    Then I click on "Declarations"
      And the radio button "true_outstanding_judgment" should be checked
      And the radio button "false_co_maker_or_endorser" should be checked
      And the radio button "false_us_citizen" should be checked
      And the radio button "true_ownership_interest" should be checked
      And the radio button "true_permanent_resident_alien" should be checked
      And the radio button "false_down_payment_borrowed" should not be checked
      And I should see "(1) What type of property did you own?"
      And I should see "(2) How did you hold title to this property?"
