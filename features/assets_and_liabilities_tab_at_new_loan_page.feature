# Feature: AssetsAndLiabilitiesTabAtNewLoanPage
#   @javascript
#   Scenario: user update subject property
#     When I am at loan management page
#       And I click on "Assets and Liabilities"
#         And I select "Condo" from ".subject_property .property_type select"
#         And I clear value in "Estimated Market Value"
#           Then I fill in "Estimated Market Value" with "123"
#         And I clear value in "Mortgage Insurance (if applicable)"
#           Then I fill in "Mortgage Insurance (if applicable)" with "456"
#         And I clear value in "Mortgage Insurance (if applicable)"
#           Then I fill in "Mortgage Insurance (if applicable)" with "789"
#         And I select "I'm not sure" from "Does your mortgage payment include escrows?"
#         And I clear value in "Homeowner’s Insurance"
#           Then I fill in "Homeowner’s Insurance" with "111"
#         And I clear value in "Property Tax"
#           Then I fill in "Property Tax" with "2222"
#         And I clear value in "HOA Due (if applicable)"
#           Then I fill in "HOA Due (if applicable)" with "333"
#         Then I click on "Save and Continue"
#         And I wait for 4 seconds
#         And I should see "Are there any outstanding judgments against you?"
#       When I click on "Assets and Liabilities"
#         And I should see "Condo"
#         And I should see "I'm not sure"
#         And the "Estimated Market Value" field should contain "123.0"
#         When I choose "Yes"
#           And I should see "Please provide the following information for all of your rental properties"
