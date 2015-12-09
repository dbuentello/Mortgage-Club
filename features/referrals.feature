Feature: Referrals
  @javascript
  Scenario: send referrals email
    When I am at my loans page
      And I turn off delayed jobs
      Then I click "Referrals"
        And I should see "Referrals Program"
        And I should see "Your Referrals"
        And I should see "Your Referral Link"
        And I should see "Invite by Email"
        And I fill in "invite-email-1" with "test1@mortgageclub.io"
        And I fill in "invite-name-1" with "Test 1"
        And I fill in "invite-phone-1" with "090 769 1123"
        And I fill in "invite-email-2" with "test2@mortgageclub.io"
        And I fill in "invite-name-2" with "Test 2"
        And I fill in "invite-phone-2" with "090 769 8322"
        And I fill in "invite-email-3" with "test3@mortgageclub.io"
        And I fill in "invite-name-3" with "Test 3"
        And I fill in "invite-phone-3" with "090 769 3333"
        Then I click on "SEND INVITES"
          Then I should see a table with the following rows:
            | Email                     | Name     | Joined | #Loans Closed |
            | test1@mortgageclub.io         | Test 1   | *      | *             |
            | test2@mortgageclub.io         | Test 2   | *      | *             |
            | test3@mortgageclub.io         | Test 3   | *      | *             |
          And the "invite-email-1" field should contain ""
          And the "invite-email-2" field should contain ""
          And the "invite-email-3" field should contain ""
          And the "invite-name-1" field should contain ""
          And the "invite-name-1" field should contain ""
          And the "invite-name-1" field should contain ""
          And the "invite-phone-1" field should contain ""
          And the "invite-phone-1" field should contain ""
          And the "invite-phone-1" field should contain ""
          Then an email should have been sent with:
            """
            From: hello@mortgageclub.co
            To: test1@mortgageclub.io
            Subject: Billy Tran has invited you to join Mortgage Club
            """
          And "test1@mortgageclub.io" should receive an email
          Then I open the email
            And I should see "<b>Billy Tran</b> has invited you to join Mortgage Club" in the email body
            And I should see "?invite_token=" in the email body
      Then I turn on delayed jobs
  @javascript
  Scenario: referrals email invalid
    When I am at my loans page
      Then I click "Referrals"
        And I fill in "invite-email-1" with "test1"
        And I fill in "invite-name-1" with "Test 1"
        And I fill in "invite-phone-1" with "090 769 1123"
        Then I click on "SEND INVITES"
          And the "invite-email-1" field should contain "test1"
          And the "invite-name-1" field should contain "Test 1"
          And the "invite-phone-1" field should contain "090 769 1123"

  @javascript
  Scenario: referrals email invalid
    When I am at my loans page
      Then I click "Referrals"
        And I fill in "invite-email-1" with "test1@mortgageclub.io"
        And I fill in "invite-name-1" with "Test 1"
        And I fill in "invite-phone-1" with "090 769 1123"
        And I fill in "invite-email-2" with "test2"
        And I fill in "invite-email-3" with "invalid-email"
        Then I click on "SEND INVITES"
          And the "invite-email-1" field should contain ""
          And the "invite-name-1" field should contain ""
          And the "invite-phone-1" field should contain ""
          Then I should see a table with the following rows:
            | Email                     | Name     | Joined | #Loans Closed |
            | test1@mortgageclub.io         | Test 1   | *      | *             |