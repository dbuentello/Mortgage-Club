Feature: UploadDocument
  @javascript
  Scenario: upload a lender documents
    When I am at loan member dashboard
      Then I click "Lender Documents"
      And I should see "This is a Wholesale Submission Form"
      Then I drag the file "spec/files/sample.pdf" to "WholesaleSubmissionForm"
        And I wait for 2 seconds
        And I should see "sample.pdf"
