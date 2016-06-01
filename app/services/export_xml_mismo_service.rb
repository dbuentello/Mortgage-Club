require "ox"

class ExportXmlMismoService
  attr_accessor :loan, :borrower, :subject_property, :primary_property, :credit_report, :params, :doc
  def initialize(loan, borrower)
    @loan = loan
    @subject_property = loan.subject_property
    # @primary_property = get_primary_property
    @borrower = loan.borrower
    @credit_report = borrower.credit_report
    @doc = Ox::Document.new(:version => "1.0")
  end

  def call
    root = Ox::Element.new("LOAN_APPLICATION")

    root << data_information_node
    root << additional_case_data_node
    root << affordable_lending_node
    root << asset_node
    root << government_reporting_node
    root << interviewer_information_node
    root << liability_node
    root << loan_product_data_node
    root << loan_purpose_node
    root << loan_qualification_node
    root << mortgage_term_node
    root << property_node
    root << proposed_housing_expense_node
    root << title_holder_node
    root << transaction_detail_node
    root << borrower_node

    @doc << root
    Ox.dump(doc)
  end

  def data_information_node
    data_information = Ox::Element.new("_DATA_INFORMATION")

    date = Ox::Element.new("DATA_VERSION")
    date["_Name"] = "Date"
    date["_Number"] = "20100512"
    data_information << date

    data_version = Ox::Element.new("DATA_VERSION")
    data_version["_Name"] = "1003"
    data_version["_Number"] = "3.20"
    data_information << data_version

    data_information
  end

  def additional_case_data_node
    additional_case_data = Ox::Element.new("ADDITIONAL_CASE_DATA")

    transmittal_data = Ox::Element.new("TRANSMITTAL_DATA")
    transmittal_data["BelowMarketSubordinateFinancingIndicator"] = ""
    transmittal_data["BuydownRatePercent"] = ""
    transmittal_data["CurrentFirstMortgageHolderType"] = ""
    transmittal_data["PropertyEstimatedValueAmount"] = ""
    transmittal_data["InvestorLoanIdentifier"] = ""
    transmittal_data["InvestorInstitutionIdentifier"] = ""
    transmittal_data["LoanOriginatorID"] = ""
    transmittal_data["LoanOriginationCompanyID"] = ""
    transmittal_data["FIPSCodeIdentifier"] = ""
    additional_case_data << transmittal_data

    additional_case_data
  end

  def affordable_lending_node
    affordable_lending = Ox::Element.new("AFFORDABLE_LENDING")
    affordable_lending["FNMCommunityLendingProductType"] = ""
    affordable_lending["FNMCommunitySecondsIndicator"] = ""
    affordable_lending["FNMNeighborsMortgageEligibilityIndicator"] = ""
    affordable_lending["HUDIncomeLimitAdjustmentFactor"] = ""
    affordable_lending["HUDLendingIncomeLimitAmount"] = ""
    affordable_lending["HUDMedianIncomeAmount"] = ""

    affordable_lending
  end

  def asset_node
    # maybe has many

    asset = Ox::Element.new("ASSET")

    asset["_CashOrMarketValueAmount"] = ""
    asset["_Type"] = ""
    asset["BorrowerID"] = ""

    asset
  end

  def government_reporting_node
    government_reporting = Ox::Element.new("GOVERNMENT_REPORTING")

    government_reporting["HMDA_HOEPALoanStatusIndicator"] = ""
    government_reporting["HMDAPreapprovalType"] = ""

    government_reporting
  end

  def interviewer_information_node
    interviewer_information = Ox::Element.new("INTERVIEWER_INFORMATION")

    interviewer_information["InterviewersEmployerStreetAddress"] = ""
    interviewer_information["InterviewersEmployerCity"] = ""
    interviewer_information["InterviewersEmployerState"] = ""
    interviewer_information["InterviewersEmployerPostalCode"] = ""
    interviewer_information["InterviewersTelephoneNumber"] = ""
    interviewer_information["ApplicationTakenMethodType"] = ""
    interviewer_information["InterviewerApplicationSignedDate"] = ""
    interviewer_information["InterviewersEmployerName"] = ""
    interviewer_information["InterviewersName"] = ""

    interviewer_information
  end

  def liability_node
    # maybe has many

    liability = Ox::Element.new("LIABILITY")

    liability["_ID"] = ""
    liability["BorrowerID"] = ""
    liability["_AccountIdentifier"] = ""
    liability["_ExclusionIndicator"] = ""
    liability["_HolderName"] = ""
    liability["_MonthlyPaymentAmount"] = ""
    liability["_PayoffStatusIndicator"] = ""
    liability["_RemainingTermMonths"] = ""
    liability["_Type"] = ""
    liability["_UnpaidBalanceAmount"] = ""
    liability["SubjectLoanResubordinationIndicator"] = ""
    liability["FNMSubjectPropertyIndicator"] = ""
    liability["FNMRentalPropertyIndicator"] = ""

    liability
  end

  def loan_product_data_node
    loan_product_data = Ox::Element.new("LOAN_PRODUCT_DATA")

    buydown = Ox::Element.new("BUYDOWN")
    buydown["_BaseDateType"] = ""
    buydown["_DurationMonths"] = ""
    buydown["_IncreaseRatePercent"] = ""
    buydown["_LenderFundingIndicator"] = ""
    buydown["_PermanentIndicator"] = ""
    loan_product_data << buydown

    loan_features = Ox::Element.new("LOAN_FEATURES")
    loan_features["BalloonIndicator"] = ""
    loan_features["EscrowWaiverIndicator"] = ""
    loan_features["GSEProjectClassificationType"] = ""
    loan_features["GSEPropertyType"] = ""
    loan_features["LienPriorityType"] = ""
    loan_features["LoanRepaymentType"] = ""
    loan_features["PaymentFrequencyType"] = ""
    loan_product_data << loan_features

    loan_product_data
  end

  def loan_purpose_node
    loan_purpose = Ox::Element.new("LOAN_PURPOSE")

    loan_purpose["GSETitleMannerHeldDescription"] = ""
    loan_purpose["_Type"] = ""
    loan_purpose["PropertyRightsType"] = ""
    loan_purpose["PropertyUsageType"] = ""

    construction_refinance_data = Ox::Element.new("CONSTRUCTION_REFINANCE_DATA")
    construction_refinance_data["RefinanceImprovementsType"] = ""
    loan_purpose << construction_refinance_data

    loan_purpose
  end

  def loan_qualification_node
    loan_qualification = Ox::Element.new("LOAN_QUALIFICATION")

    loan_qualification["AdditionalBorrowerAssetsNotConsideredIndicator"] = ""
    loan_qualification["AdditionalBorrowerAssetsConsideredIndicator"] = ""

    loan_qualification
  end

  def mortgage_term_node
    mortgage_terms = Ox::Element.new("MORTGAGE_TERMS")

    mortgage_terms["BaseLoanAmount"] = ""
    mortgage_terms["LenderCaseIdentifier"] = ""
    mortgage_terms["LoanAmortizationTermMonths"] = ""
    mortgage_terms["LoanAmortizationType"] = ""
    mortgage_terms["MortgageType"] = ""
    mortgage_terms["RequestedInterestRatePercent"] = ""

    mortgage_terms
  end

  def property_node
    property = Ox::Element.new("PROPERTY")

    property["_StreetAddress"] = ""
    property["_City"] = ""
    property["_State"] = ""
    property["_PostalCode"] = ""
    property["_FinancedNumberOfUnits"] = ""
    property["_StructureBuiltYear"] = ""

    legal_description = Ox::Element.new("_LEGAL_DESCRIPTION")
    legal_description["_Type"] = ""
    property << legal_description

    parsed_street_address = Ox::Element.new("PARSED_STREET_ADDRESS")
    parsed_street_address["_HouseNumber"] = ""
    parsed_street_address["_StreetName"] = ""
    property << parsed_street_address

    valuation = Ox::Element.new("_VALUATION")
    valuation["_MethodType"] = ""

    appraiser = Ox::Element.new("APPRAISER")
    appraiser["_Name"] = ""
    appraiser["_CompanyName"] = ""
    appraiser["_LicenseIdentifier"] = ""
    appraiser["_LicenseState"] = ""
    appraiser["_SupervisoryAppraiserLicenseNumber"] = ""
    valuation << appraiser
    property << valuation

    property
  end

  def proposed_housing_expense_node
    # maybe has many

    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = ""
    proposed_housing_expense["_PaymentAmount"] = ""

    proposed_housing_expense
  end

  def title_holder_node
    title_holder = Ox::Element.new("TITLE_HOLDER")

    title_holder["_Name"] = ""

    title_holder
  end

  def transaction_detail_node
    transaction_detail = Ox::Element.new("TRANSACTION_DETAIL")

    transaction_detail["AlterationsImprovementsAndRepairsAmount"] = ""
    transaction_detail["BorrowerPaidDiscountPointsTotalAmount"] = ""
    transaction_detail["EstimatedClosingCostsAmount"] = ""
    transaction_detail["MIAndFundingFeeFinancedAmount"] = ""
    transaction_detail["MIAndFundingFeeTotalAmount"] = ""
    transaction_detail["PrepaidItemsEstimatedAmount"] = ""
    transaction_detail["PurchasePriceAmount"] = ""
    transaction_detail["RefinanceIncludingDebtsToBePaidOffAmount"] = ""
    transaction_detail["SellerPaidClosingCostsAmount"] = ""
    transaction_detail["SubordinateLienAmount"] = ""
    transaction_detail["FNMCostOfLandAcquiredSeparatelyAmount"] = ""
    transaction_detail[""] = ""

    purchase_credit = Ox::Element.new("PURCHASE_CREDIT")
    purchase_credit["_Amount"] = ""
    purchase_credit["_SourceType"] = ""
    transaction_detail << purchase_credit

    transaction_detail
  end

  def borrower_node
    borrower_element = Ox::Element.new("BORROWER")

    borrower_element["BorrowerID"] = ""
    borrower_element["_FirstName"] = ""
    borrower_element["_LastName"] = ""
    borrower_element["_AgeAtApplicationYears"] = ""
    borrower_element["_BirthDate"] = ""
    borrower_element["_HomeTelephoneNumber"] = ""
    borrower_element["_PrintPositionType"] = ""
    borrower_element["_SSN"] = ""
    borrower_element["JointAssetLiabilityReportingType"] = ""
    borrower_element["MaritalStatusType"] = ""
    borrower_element["SchoolingYears"] = ""

    mail_to = Ox::Element.new("_MAIL_TO")
    mail_to["_StreetAddress"] = ""
    mail_to["_City"] = ""
    mail_to["_State"] = ""
    mail_to["_PostalCode"] = ""
    mail_to["_Country"] = ""
    borrower_element << mail_to

    residence = Ox::Element.new("_RESIDENCE")
    residence["_StreetAddress"] = ""
    residence["_City"] = ""
    residence["_State"] = ""
    residence["_PostalCode"] = ""
    residence["BorrowerResidencyBasisType"] = ""
    residence["BorrowerResidencyDurationMonths"] = ""
    residence["BorrowerResidencyDurationYears"] = ""
    residence["BorrowerResidencyType"] = ""
    borrower_element << residence

    # maybe has many
    current_income = Ox::Element.new("CURRENT_INCOME")
    current_income["IncomeType"] = ""
    current_income["_MonthlyTotalAmount"] = ""
    borrower_element << current_income

    declaration = Ox::Element.new("DECLARATION")
    declaration["AlimonyChildSupportObligationIndicator"] = ""
    declaration["BankruptcyIndicator"] = ""
    declaration["BorrowedDownPaymentIndicator"] = ""
    declaration["CitizenshipResidencyType"] = ""
    declaration["CoMakerEndorserOfNoteIndicator"] = ""
    declaration["HomeownerPastThreeYearsType"] = ""
    declaration["IntentToOccupyType"] = ""
    declaration["LoanForeclosureOrJudgementIndicator"] = ""
    declaration["OutstandingJudgementsIndicator"] = ""
    declaration["PartyToLawsuitIndicator"] = ""
    declaration["PresentlyDelinquentIndicator"] = ""
    declaration["PropertyForeclosedPastSevenYearsIndicator"] = ""
    borrower_element << declaration

    employer = Ox::Element.new("EMPLOYER")
    employer["_Name"] = ""
    employer["CurrentEmploymentMonthsOnJob"] = ""
    employer["CurrentEmploymentTimeInLineOfWorkYears"] = ""
    employer["CurrentEmploymentYearsOnJob"] = ""
    employer["EmploymentBorrowerSelfEmployedIndicator"] = ""
    employer["EmploymentCurrentIndicator"] = ""
    employer["EmploymentPrimaryIndicator"] = ""
    borrower_element << employer

    government_monitoring = Ox::Element.new("GOVERNMENT_MONITORING")
    government_monitoring["GenderType"] = ""
    government_monitoring["RaceNationalOriginRefusalIndicator"] = ""
    government_monitoring["HMDAEthnicityType"] = ""

    hmda_race = Ox::Element.new("HMDA_RACE")
    hmda_race["_Type"] = ""
    government_monitoring << hmda_race
    borrower_element << government_monitoring

    # maybe has many
    present_housing_expense = Ox::Element.new("PRESENT_HOUSING_EXPENSE")
    present_housing_expense["HousingExpenseType"] = ""
    borrower_element << present_housing_expense

    # maybe has many
    summary = Ox::Element.new("SUMMARY")
    summary["_Amount"] = ""
    summary["_AmountType"] = ""
    borrower_element << summary

    contact_point = Ox::Element.new("CONTACT_POINT")
    contact_point["_Type"] = ""
    contact_point["_Value"] = ""
    borrower_element << contact_point

    borrower_element
  end
end
