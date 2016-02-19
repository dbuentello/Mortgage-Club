Feature: Dashboard
  @javascript
  Scenario: add a new checklist
    When I am at loan member dashboard
      Then I click "Checklists"
      And I should see "Add a new checklist"
      Then I click on selectpicker "checklistTypes" and select "Upload"
      #  And I click on "Upload"

      Then I select "Upload" from "checklist[checklist_type]"
      And I fill in "Due Date" with "03/01/2015"
      And I fill in "Name" with "This is a name of checklist"
      And I fill in "Info" with "This is a information of checklist"
      And I select "Borrower" from "checklist[subject_name]"
        Then I should see "W2 - Most recent tax year"
      And I select "Paystub - Previous month" from "checklist[document_type]"
        Then the "description" field should contain "Paystub - Previous month"
      And I click on "Submit"
      Then I should see "This is a name of checklist"
        
  @javascript
  Scenario: edit a new checklist
    When I am at loan member dashboard
      Then I click "Checklists"
      Then I click link with div ".icon-pencil7"
        And I should see "Edit Checklist"
      Then I fill in "Name" with "This is a name of checklist"
      And I fill in "Info" with "This is a information of checklist"
      And I select "Borrower" from "checklist[subject_name]"
      And I select "W2 - Most recent tax year" from "checklist[document_type]"
        Then I should see "W2 - Most recent tax year"
      And I click on "Submit"
      Then I should see "This is a name of checklist"
        And I should see "This is a information of checklist"
