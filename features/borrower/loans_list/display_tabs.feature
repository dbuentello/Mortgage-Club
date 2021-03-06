@ignore
Feature: DisplayTabs
  @javascript
  Scenario: display loans, referrals and settings tabs
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And I login as "testing@man.net" with password "secretpass"
    Then I go to the my loans page
      And I should see "Loans"
      And I should see "Referrals"
