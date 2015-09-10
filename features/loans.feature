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