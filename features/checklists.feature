Feature: Dashboard
  @javascript
  Scenario: add a new checklist
    When I am at loan member dashboard
      Then I click "Checklists"
      And I should see "Add a new checklist"
      Then I select "Upload" from "checklist[checklist_type]"
      And I fill in "Due Date" with "03/01/2015"
      And I fill in "Name" with "This is a name of checklist"
      And I fill in "Info" with "This is a information of checklist"
      And I select "Borrower" from "checklist[document]"
        Then I should see "W2 - Most recent tax year"
      And I select "Paystub - Previous month" from "checklist[document_type]"
        Then the "description" field should contain "Paystub - Previous month"
      And I click on "Submit"
      Then I should see a table with the following rows:
        | Name                        | Type     | Due Date   | Status  | Owner        |
        | This is a name of checklist | upload   | 03/01/2015 | pending | Mark Lim     |
        | *                           | *        | *          | *       | *            |

  @javascript
  Scenario: edit a new checklist
    When I am at loan member dashboard
      Then I click "Checklists"
        And I should see "Edit"
      Then I click on "Edit"
        And I should see "Edit Checklist"
      Then I fill in "Name" with "This is a name of checklist"
      And I fill in "Info" with "This is a information of checklist"
      And I select "Property" from "checklist[document]"
      And I select "Termite report" from "checklist[document_type]"
        Then I should see "Termite report"
      And I click on "Submit"
      Then I should see "Updated successfully"
