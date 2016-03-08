Feature: AssetsAndLiabilitiesTabAtNewLoanPage
  @javascript
  Scenario: user update asset with loan purchase
    When I am at loan management page
      And I click link with div "#tabProperty a"
        And I clear value in "Property Address"
        Then I fill in "Property Address" with "1920 South Las Vegas Boulevard, Las Vegas"
        And I wait for 2 seconds
        And I select "Vacation Home" from "Property Will Be"
        And I clear value in "Estimated Rental Income"
          Then I fill in "Estimated Rental Income" with "$1,111.00"
        And I choose "true_purpose"
        And I clear value in "Purchase Price"
          Then I fill in "Purchase Price" with "$400,000.00"
          Then I click on "Save and Continue"
        And I should see "I am applying"
      When I click link with div "#tabAssetsAndLiabilities"
        And I clear value in "Institution Name"
          Then I fill in "Institution Name" with "Bank of America"
        And I select "Checking" from "Asset Type"
        And I clear value in "Current Balance"
          Then I fill in "Current Balance" with "$100.00"
        And I should see "The property you're buying"
        And I should not see "Mortgage Payment"
        And I select "Single Family Home" from "property_property_type_subject_property"
        And I clear value in "property_market_price_subject_property"
          Then I fill in "property_market_price_subject_property" with "$400,000.00"
        And I clear value in "property_estimated_hazard_insurance_subject_property"
          Then I fill in "property_estimated_hazard_insurance_subject_property" with "$10.00"
        And I clear value in "property_estimated_property_tax_subject_property"
          Then I fill in "property_estimated_property_tax_subject_property" with "$100.00"
        And I clear value in "property_market_price_primary_property"
          Then I fill in "property_market_price_primary_property" with "$400,000.00"
        And I clear value in "property_estimated_hazard_insurance_primary_property"
          Then I fill in "property_estimated_hazard_insurance_primary_property" with "$10.00"
        And I clear value in "property_estimated_property_tax_primary_property"
          Then I fill in "property_estimated_property_tax_primary_property" with "$100.00"
      And I click on "Save and Continue"
        Then I should see "Are there any outstanding judgments against you?"

  @javascript
  Scenario: user update asset with loan refinance
    When I am at loan management page
      And I click link with div "#tabProperty a"
        And I clear value in "Property Address"
          Then I fill in "Property Address" with "1920 South Las Vegas Boulevard, Las Vegas"
        And I wait for 2 seconds
        And I select "Vacation Home" from "Property Will Be"
        And I clear value in "Estimated Rental Income"
          Then I fill in "Estimated Rental Income" with "$1,111.00"
        And I choose "false_purpose"
        And I clear value in "Original Purchase Price"
          Then I fill in "Original Purchase Price" with "$400,000.00"
        And I clear value in "Purchase Year"
          Then I fill in "Purchase Year" with "1994"
        Then I click on "Save and Continue"
        And I should see "I am applying"
      When I click link with div "#tabAssetsAndLiabilities"
        And I clear value in "Institution Name"
          Then I fill in "Institution Name" with "Bank of America"
        And I select "Checking" from "Asset Type"
        And I clear value in "Current Balance"
          Then I fill in "Current Balance" with "$100.00"
        And I should see "The property you're refinancing"
        And I select "Single Family Home" from "property_property_type_subject_property"
        And I clear value in "property_market_price_subject_property"
          Then I fill in "property_market_price_subject_property" with "$400,000.00"
        And I select "Yes, include my property taxes and insurance" from "property_mortgage_includes_escrows_subject_property"
        And I clear value in "property_estimated_hazard_insurance_subject_property"
          Then I fill in "property_estimated_hazard_insurance_subject_property" with "$10.00"
        And I clear value in "property_estimated_property_tax_subject_property"
          Then I fill in "property_estimated_property_tax_subject_property" with "$100.00"
        And I clear value in "property_market_price_primary_property"
          Then I fill in "property_market_price_primary_property" with "$400,000.00"
        And I select "Yes, include my property taxes and insurance" from "property_mortgage_includes_escrows_primary_property"
        And I clear value in "property_estimated_hazard_insurance_primary_property"
          Then I fill in "property_estimated_hazard_insurance_primary_property" with "$10.00"
        And I clear value in "property_estimated_property_tax_primary_property"
          Then I fill in "property_estimated_property_tax_primary_property" with "$100.00"
      And I click on "Save and Continue"
        Then I should see "Are there any outstanding judgments against you?"

  @javascript
  Scenario: user update primary and subject with the same address
    When I am at loan management page
      And I click link with div "#tabProperty a"
        And I clear value in "Property Address"
          Then I fill in "Property Address" with "1920 South Las Vegas Boulevard, Las Vegas"
        And I wait for 2 seconds
        And I select "Vacation Home" from "Property Will Be"
        And I clear value in "Estimated Rental Income"
          Then I fill in "Estimated Rental Income" with "$1,111.00"
        And I choose "false_purpose"
        And I clear value in "Original Purchase Price"
          Then I fill in "Original Purchase Price" with "$400,000.00"
        And I clear value in "Purchase Year"
          Then I fill in "Purchase Year" with "1994"
        Then I click on "Save and Continue"
        And I should see "I am applying"
        And I clear value in "Your Current Address"
          Then I fill in "Your Current Address" with "1920 South Las Vegas Boulevard, Las Vegas"
        And I wait for 2 seconds
        And I choose "true_first_borrower_currently_own"
        Then I click on "Save and Continue"
        And I should see "At the minimum"
      When I click link with div "#tabAssetsAndLiabilities"
        And I clear value in "Institution Name"
          Then I fill in "Institution Name" with "Bank of America"
        And I select "Checking" from "Asset Type"
        And I clear value in "Current Balance"
          Then I fill in "Current Balance" with "$100.00"
        And I should see "The property you're refinancing"
        And I should not see "Your primary residence"
        And I select "Single Family Home" from "property_property_type_subject_property"
        And I clear value in "property_market_price_subject_property"
          Then I fill in "property_market_price_subject_property" with "$400,000.00"
        And I select "Yes, include my property taxes and insurance" from "property_mortgage_includes_escrows_subject_property"
        And I clear value in "property_estimated_hazard_insurance_subject_property"
          Then I fill in "property_estimated_hazard_insurance_subject_property" with "$10.00"
        And I clear value in "property_estimated_property_tax_subject_property"
          Then I fill in "property_estimated_property_tax_subject_property" with "$100.00"
      And I click on "Save and Continue"
        Then I should see "Are there any outstanding judgments against you?"

