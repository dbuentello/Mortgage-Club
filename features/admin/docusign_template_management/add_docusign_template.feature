Feature: AddDocusignTemplate
  @javascript
  Scenario: add a docusign template
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Docusign Templates"
    Then I click "Docusign Templates"
      And I should see "Docusign Template - Management"
      And I should see "Add new Docusign Template"
    Then I select "Loan Estimate" from "Name"
      And I fill in "State" with "California"
      And I fill in "Description" with "Description"
      And I fill in "Email Subject" with "Email Subject"
      And I fill in "Email Body" with "Email Body"
      And I fill in "Docusign Id" with "Docusign Id"
      And I fill in "Document Order" with "1"
    Then I click on "Submit"
    Then I should see a table with the following rows:
      | Name | Docusign Id |*       |
      | Loan Estimate | Docusign Id |*       |
