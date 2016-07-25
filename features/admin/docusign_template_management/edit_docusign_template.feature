Feature: EditDocusignTemplate
  @javascript
  Scenario: edit an docusign template
    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
    Given there is a template with the name "Loan Estimate" and with the state "California" and the description "sample description" and the email subject "Hello" and the email body "Sample body" and the docusign id "docusign id" and the document order "1"
      And there is a loans members association
      And I login as "admin@man.net" with password "secretpass"
    Then I should see "Admin"
      And I click "Admin"
      And I should see "Docusign Templates"
    Then I click "Docusign Templates"
      And I should see "Docusign Template - Management"
      And I should see "Edit"
      And I click on "Edit" in the ".linkTypeReversed"
    Then I fill in "Docusign Id" with "New Docusign Id"
    Then I click on "Submit"
      And the "Docusign Id" field should contain "New Docusign Id"
