Feature: AddRequest
  @javascript
  Scenario: add a request
    When I am at loan member dashboard
      And I turn off delayed jobs
      And I go to the loan members lead requests page
        And I should see "Leads Management"
        And I should see "Request"
      Then I click on "Request"
        And I wait for 2 seconds
        And I press "Yes" in the modal "request"
        And I should see "Sent"
      Then an email should have been sent with:
        """
        From: loan_member@mortgageclub.co
        To: cuongvu0103@gmail.com
        Subject: I'd like to claim a loan
        """
      And "cuongvu0103@gmail.com" should receive an email
      Then I open the email
        And I should see "I'd like to claim the loan of" in the email body
      Then I turn on delayed jobs
