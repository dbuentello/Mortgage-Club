require "ox"

class ExportXmlMismoService
  attr_accessor :loan, :borrower, :subject_property, :primary_property, :credit_report, :params, :doc, :loan_member, :assets
  def initialize(loan, borrower)
    @loan = loan
    @borrower = borrower

    @subject_property = loan.subject_property
    @primary_property = get_primary_property
    @credit_report = borrower.credit_report
    @loan_member = loan.loans_members_associations.first.loan_member
    @assets = borrower.assets

    @doc = Ox::Document.new(:version => "1.0")
  end

  def call
    root = Ox::Element.new("LOAN_APPLICATION")

    root << data_information_node
    root << additional_case_data_node
    root << affordable_lending_node

    assets.each do |asset|
      root << asset_node(asset)
    end

    root << government_reporting_node
    root << interviewer_information_node

    credit_report.liabilities.each_with_index do |liability, index|
      root << liability_node(liability, index)
    end

    root << loan_product_data_node
    root << loan_purpose_node
    root << loan_qualification_node
    root << mortgage_term_node
    root << property_node

    root << proposed_housing_expense_node_of_first_mortgage
    root << proposed_housing_expense_node_of_hazard_insurance
    root << proposed_housing_expense_node_of_estate_tax
    root << proposed_housing_expense_node_of_homeowner

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
    date["_Number"] = DateTime.now.strftime("%Y%m%d")
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
    transmittal_data["LoanOriginatorID"] = loan_member.nmls_id.to_s
    transmittal_data["LoanOriginationCompanyID"] = loan_member.company_nmls.to_s
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

  def asset_node(borrower_asset)
    asset = Ox::Element.new("ASSET")
    asset["_CashOrMarketValueAmount"] = borrower_asset.current_balance.to_s
    asset["_Type"] = get_asset_type(borrower_asset.asset_type)
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

    interviewer_information["InterviewersEmployerStreetAddress"] = "156 2nd St"
    interviewer_information["InterviewersEmployerCity"] = "San Francisco"
    interviewer_information["InterviewersEmployerState"] = "CA"
    interviewer_information["InterviewersEmployerPostalCode"] = "94105"
    interviewer_information["InterviewersTelephoneNumber"] = loan_member.phone_number.to_s.gsub!(/[() -]/, "")
    interviewer_information["ApplicationTakenMethodType"] = "I"
    interviewer_information["InterviewerApplicationSignedDate"] = ""
    interviewer_information["InterviewersEmployerName"] = loan_member.company_name.to_s
    interviewer_information["InterviewersName"] = loan_member.user.to_s

    interviewer_information
  end

  def liability_node(borrower_liability, index)
    liability = Ox::Element.new("LIABILITY")

    liability["_ID"] = "Liab#{index + 1}"
    liability["BorrowerID"] = ""
    liability["_AccountIdentifier"] = ""
    liability["_ExclusionIndicator"] = ""
    liability["_HolderName"] = borrower_liability.name.to_s
    liability["_MonthlyPaymentAmount"] = borrower_liability.payment.to_s
    liability["_PayoffStatusIndicator"] = ""
    liability["_RemainingTermMonths"] = borrower_liability.months.to_s
    liability["_Type"] = borrower_liability.account_type.to_s
    liability["_UnpaidBalanceAmount"] = borrower_liability.balance.to_s
    liability["SubjectLoanResubordinationIndicator"] = ""
    # todo
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
    loan_features["BalloonIndicator"] = loan.balloon_payment_text.nil? ? "N" : "Y"
    loan_features["EscrowWaiverIndicator"] = ""
    loan_features["GSEProjectClassificationType"] = ""
    loan_features["GSEPropertyType"] = subject_property.property_type.to_s == "condo" ? "03" : "01"
    loan_features["LienPriorityType"] = "1"
    loan_features["LoanRepaymentType"] = "N"
    loan_features["PaymentFrequencyType"] = ""
    loan_product_data << loan_features

    loan_product_data
  end

  def loan_purpose_node
    loan_purpose = Ox::Element.new("LOAN_PURPOSE")

    loan_purpose["GSETitleMannerHeldDescription"] = ""
    # todo
    loan_purpose["_Type"] = ""
    loan_purpose["PropertyRightsType"] = "1"
    # todo
    loan_purpose["PropertyUsageType"] = ""

    construction_refinance_data = Ox::Element.new("CONSTRUCTION_REFINANCE_DATA")
    construction_refinance_data["RefinanceImprovementsType"] = ""
    loan_purpose << construction_refinance_data

    loan_purpose
  end

  def loan_qualification_node
    loan_qualification = Ox::Element.new("LOAN_QUALIFICATION")

    loan_qualification["AdditionalBorrowerAssetsNotConsideredIndicator"] = "N"
    loan_qualification["AdditionalBorrowerAssetsConsideredIndicator"] = "N"

    loan_qualification
  end

  def mortgage_term_node
    mortgage_terms = Ox::Element.new("MORTGAGE_TERMS")

    mortgage_terms["BaseLoanAmount"] = loan.amount.to_s
    mortgage_terms["LenderCaseIdentifier"] = ""
    mortgage_terms["LoanAmortizationTermMonths"] = loan.num_of_months.to_s
    mortgage_terms["LoanAmortizationType"] = get_amortization_type(loan.amortization_type)
    mortgage_terms["MortgageType"] = loan.loan_type
    mortgage_terms["RequestedInterestRatePercent"] = loan.interest_rate.to_s

    mortgage_terms
  end

  def property_node
    property = Ox::Element.new("PROPERTY")

    address = subject_property.address
    property["_StreetAddress"] = address.nil? ? "" : address.street_address
    property["_City"] = address.nil? ? "" : address.city
    property["_State"] = address.nil? ? "" : address.state
    property["_PostalCode"] = address.nil? ? "" : address.zip
    # todo
    property["_FinancedNumberOfUnits"] = ""
    property["_StructureBuiltYear"] = ""

    legal_description = Ox::Element.new("_LEGAL_DESCRIPTION")
    legal_description["_Type"] = "F1"
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

  def proposed_housing_expense_node_of_first_mortgage
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = "26"
    proposed_housing_expense["_PaymentAmount"] = loan.monthly_payment.to_s

    proposed_housing_expense
  end

  def proposed_housing_expense_node_of_hazard_insurance
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = "01"
    proposed_housing_expense["_PaymentAmount"] = subject_property.estimated_hazard_insurance.to_s

    proposed_housing_expense
  end

  def proposed_housing_expense_node_of_estate_tax
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = "14"
    proposed_housing_expense["_PaymentAmount"] = subject_property.estimated_property_tax.to_s

    proposed_housing_expense
  end

  def proposed_housing_expense_node_of_homeowner
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = "06"
    proposed_housing_expense["_PaymentAmount"] = ""

    proposed_housing_expense
  end

  def title_holder_node
    title_holder = Ox::Element.new("TITLE_HOLDER")

    title_holder["_Name"] = borrower.user.to_s

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
    borrower_element["_FirstName"] = borrower.user.first_name.to_s
    borrower_element["_LastName"] = borrower.user.last_name.to_s
    borrower_element["_AgeAtApplicationYears"] = ""
    borrower_element["_BirthDate"] = borrower.dob.nil? ? "" : borrower.dob.strftime("%Y%m%d")
    borrower_element["_HomeTelephoneNumber"] = borrower.phone.to_s.gsub!(/[() -]/, "")
    borrower_element["_PrintPositionType"] = ""
    borrower_element["_SSN"] = borrower.ssn.to_s.gsub!(/[() -]/, "")
    borrower_element["JointAssetLiabilityReportingType"] = ""
    borrower_element["MaritalStatusType"] = get_marital_status(borrower.marital_status)
    borrower_element["SchoolingYears"] = borrower.years_in_school.to_s

    borrower_address = borrower.current_address.address
    mail_to = Ox::Element.new("_MAIL_TO")
    mail_to["_StreetAddress"] = borrower_address.nil? ? "" : borrower_address.street_address
    mail_to["_City"] = borrower_address.nil? ? "" : borrower_address.city
    mail_to["_State"] = borrower_address.nil? ? "" : borrower_address.state
    mail_to["_PostalCode"] = borrower_address.nil? ? "" : borrower_address.zip
    mail_to["_Country"] = "US"
    borrower_element << mail_to

    residence = Ox::Element.new("_RESIDENCE")
    residence["_StreetAddress"] = borrower_address.nil? ? "" : borrower_address.street_address
    residence["_City"] = borrower_address.nil? ? "" : borrower_address.city
    residence["_State"] = borrower_address.nil? ? "" : borrower_address.state
    residence["_PostalCode"] = borrower_address.nil? ? "" : borrower_address.zip
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

    borrower_declaration = borrower.declaration
    declaration = Ox::Element.new("DECLARATION")
    declaration["AlimonyChildSupportObligationIndicator"] = get_declaration(borrower_declaration.child_support)
    declaration["BankruptcyIndicator"] = get_declaration(borrower_declaration.bankrupt)
    declaration["BorrowedDownPaymentIndicator"] = get_declaration(borrower_declaration.down_payment_borrowed)
    declaration["CitizenshipResidencyType"] =  ""
    declaration["CoMakerEndorserOfNoteIndicator"] = get_declaration(borrower_declaration.co_maker_or_endorser)
    declaration["HomeownerPastThreeYearsType"] = ""
    declaration["IntentToOccupyType"] = ""
    declaration["LoanForeclosureOrJudgementIndicator"] = get_declaration(borrower_declaration.loan_foreclosure)
    declaration["OutstandingJudgementsIndicator"] = get_declaration(borrower_declaration.outstanding_judgment)
    declaration["PartyToLawsuitIndicator"] = get_declaration(borrower_declaration.party_to_lawsuit)
    declaration["PresentlyDelinquentIndicator"] = get_declaration(borrower_declaration.present_delinquent_loan)
    declaration["PropertyForeclosedPastSevenYearsIndicator"] = get_declaration(borrower_declaration.property_foreclosed)
    borrower_element << declaration

    employer = Ox::Element.new("EMPLOYER")
    employer["_Name"] = ""
    employer["CurrentEmploymentMonthsOnJob"] = ""
    employer["CurrentEmploymentTimeInLineOfWorkYears"] = ""
    employer["CurrentEmploymentYearsOnJob"] = ""
    employer["EmploymentBorrowerSelfEmployedIndicator"] = ""
    employer["EmploymentCurrentIndicator"] = ""
    borrower_element << employer

    # government_monitoring = Ox::Element.new("GOVERNMENT_MONITORING")
    # government_monitoring["GenderType"] = ""
    # government_monitoring["RaceNationalOriginRefusalIndicator"] = ""
    # government_monitoring["HMDAEthnicityType"] = ""

    # hmda_race = Ox::Element.new("HMDA_RACE")
    # hmda_race["_Type"] = ""
    # government_monitoring << hmda_race
    # borrower_element << government_monitoring

    # maybe has many
    # present_housing_expense = Ox::Element.new("PRESENT_HOUSING_EXPENSE")
    # present_housing_expense["HousingExpenseType"] = ""
    # borrower_element << present_housing_expense

    # maybe has many
    # summary = Ox::Element.new("SUMMARY")
    # summary["_Amount"] = ""
    # summary["_AmountType"] = ""
    # borrower_element << summary

    contact_point = Ox::Element.new("CONTACT_POINT")
    contact_point["_Type"] = "Email"
    contact_point["_Value"] = borrower.user.email
    borrower_element << contact_point

    borrower_element
  end

  def get_primary_property
    return unless loan.primary_property

    if subject_property_and_primary_property_have_same_address?(loan.primary_property)
      return loan.subject_property
    else
      return loan.primary_property
    end
  end

  def subject_property_and_primary_property_have_same_address?(primary_property)
    return false unless subject_address = subject_property.address
    return false unless primary_address = primary_property.address

    subject_address.city == primary_address.city &&
      subject_address.state == primary_address.state &&
      subject_address.street_address == primary_address.street_address &&
      subject_address.zip == primary_address.zip
  end

  def get_asset_type(asset_type)
    case asset_type
    when "checkings"
      return "03"
    when "savings"
      return "F3"
    when "investment"
      return "05"
    when "retirement"
      return "08"
    when "other"
      return "OL"
    else
      return ""
    end
  end

  def get_amortization_type(amortization_type)
    return "" if amortization_type.nil?

    if amortization_type == "5 year ARM"
      return "01"
    else
      return "05"
    end
  end

  def get_marital_status(marital_status)
    case marital_status
    when "married"
      return "M"
    when "unmarried"
      return "U"
    when "separated"
      return "S"
    else
      return ""
    end
  end

  def get_declaration(declaration)
    return "N" if borrower.declaration.nil?

    declaration == true ? "Y" : "N"
  end
end
