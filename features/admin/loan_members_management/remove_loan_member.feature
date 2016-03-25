# Feature: RemoveLoanMember
#  @javascript
#  Scenario: remove a member
#    Given there is a admin with the first name "Admin" and with the email "admin@man.net" and the password "secretpass" and the password confirmation "secretpass"
#      And there is a loans members association
#      And I login as "admin@man.net" with password "secretpass"
#    Then I should see "Admin"
#      And I click "Admin"
#      And I should see "Loan Members"
#    Then I click "Loan Members"
#      And I should see "Loan Members"
#      And I should see "Edit"
#      And I click on "Edit"
#    Then I click on "Remove"
#      And I press "Yes" in the modal "removeLoanMember"
#    Then I should be on the loan member managements page