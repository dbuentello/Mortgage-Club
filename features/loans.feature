Feature: Loans
  @javascript
  Scenario: moves to Loans index page
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And I login as "testing@man.net" with password "secretpass"
    Then I go to the my loans page
      And I should see "Loans"
      And I should see "Referrals"
      And I should see "Settings"

  @javascript
  Scenario: click on tabs
    When I am at my loans page
      Then I click "Referrals"
        And I should see "Referrals Program"
        And I should see "Your Referrals"
        And I should see "Your Referral Link"
        And I should see "Invite by Email"
        And I fill in "invite-email-1" with "test1@example.com"
        And I fill in "invite-name-1" with "Test 1"
        And I fill in "invite-phone-1" with "090 769 1123"
        And I fill in "invite-email-2" with "test2@example.com"
        And I fill in "invite-name-2" with "Test 2"
        And I fill in "invite-phone-2" with "090 769 8322"
        And I fill in "invite-email-3" with "test3@example.com"
        And I fill in "invite-name-3" with "Test 3"
        And I fill in "invite-phone-3" with "090 769 3333"
        Then I click on "SEND INVITES"
          And the "invite-email-1" field should contain ""
          And the "invite-email-2" field should contain ""
          And the "invite-email-3" field should contain ""
          And the "invite-name-1" field should contain ""
          And the "invite-name-1" field should contain ""
          And the "invite-name-1" field should contain ""
          And the "invite-phone-1" field should contain ""
          And the "invite-phone-1" field should contain ""
          And the "invite-phone-1" field should contain ""
        And I fill in "invite-email-1" with "test1"
        And I fill in "invite-name-1" with "Test 1"
        And I fill in "invite-phone-1" with "090 769 1123"
        Then I click on "SEND INVITES"
          And the "invite-email-1" field should contain "test1"
          And the "invite-name-1" field should contain "Test 1"
          And the "invite-phone-1" field should contain "090 769 1123"
        And I wait for 10 seconds