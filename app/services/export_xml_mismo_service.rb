# rubocop:disable ClassLength
# rubocop:disable AbcSize
require "ox"

class ExportXmlMismoService
  attr_accessor :loan, :borrower, :subject_property, :credit_report, :params, :doc, :loan_member, :assets, :co_borrower
  def initialize(loan, borrower)
    @loan = loan
    @borrower = borrower
    @co_borrower = loan.secondary_borrower

    @subject_property = loan.subject_property
    @credit_report = borrower.credit_report
    @loan_member = loan.loans_members_associations.first.loan_member
    @assets = borrower.assets

    @doc = Ox::Document.new(version: "1.0")
  end

  def call
    root = Ox::Element.new("LOAN_APPLICATION")

    root << data_information_node
    root << additional_case_data_node

    assets.each do |asset|
      root << asset_node(asset)
    end

    root << interviewer_information_node

    if credit_report.present?
      credit_report.liabilities.each_with_index do |liability, index|
        root << liability_node(liability, index)
      end
    end

    root << loan_product_data_node
    root << loan_purpose_node
    root << loan_qualification_node
    root << mortgage_term_node
    root << property_node

    root << proposed_housing_expense_node_of_first_mortgage
    root << proposed_housing_expense_node_of_hazard_insurance
    root << proposed_housing_expense_node_of_estate_tax
    root << proposed_housing_expense_node_of_mortgage_insurance
    root << proposed_housing_expense_node_of_homeowner
    root << proposed_housing_expense_node_of_other_mortgage
    root << proposed_housing_expense_node_of_other_housing

    root << title_holder_node
    root << transaction_detail_node
    root << borrower_node(borrower, true)
    root << borrower_node(co_borrower, false) if co_borrower.present?

    @doc << root
    Ox.dump(doc)
  end

  def data_information_node
    data_information = Ox::Element.new("_DATA_INFORMATION")

    date = Ox::Element.new("DATA_VERSION")
    date["_Name"] = "Date"
    date["_Number"] = Time.zone.now.strftime("%Y%m%d")
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
    transmittal_data["LoanOriginatorID"] = loan_member.nmls_id.to_s
    transmittal_data["LoanOriginationCompanyID"] = loan_member.company_nmls.to_s
    additional_case_data << transmittal_data

    additional_case_data
  end

  def asset_node(borrower_asset)
    asset = Ox::Element.new("ASSET")

    asset["_CashOrMarketValueAmount"] = borrower_asset.current_balance.to_s
    asset["_Type"] = get_asset_type(borrower_asset.asset_type)

    asset
  end

  def interviewer_information_node
    interviewer_information = Ox::Element.new("INTERVIEWER_INFORMATION")

    interviewer_information["InterviewersEmployerStreetAddress"] = "156 2nd St"
    interviewer_information["InterviewersEmployerCity"] = "San Francisco"
    interviewer_information["InterviewersEmployerState"] = "CA"
    interviewer_information["InterviewersEmployerPostalCode"] = "94105"
    interviewer_information["InterviewersTelephoneNumber"] = loan_member.phone_number.to_s.gsub!(/[() -]/, "")
    interviewer_information["ApplicationTakenMethodType"] = "I"
    interviewer_information["InterviewersEmployerName"] = loan_member.company_name.to_s
    interviewer_information["InterviewersName"] = loan_member.user.to_s

    interviewer_information
  end

  def liability_node(borrower_liability, index)
    liability = Ox::Element.new("LIABILITY")

    liability["_ID"] = "Liab#{index + 1}"
    liability["_HolderName"] = borrower_liability.name.to_s
    liability["_MonthlyPaymentAmount"] = borrower_liability.payment.to_s
    liability["_RemainingTermMonths"] = borrower_liability.months.to_s
    liability["_Type"] = get_liability_type(borrower_liability.account_type)
    liability["_UnpaidBalanceAmount"] = borrower_liability.balance.to_s
    # todo
    liability["FNMSubjectPropertyIndicator"] = ""
    liability["FNMRentalPropertyIndicator"] = ""

    liability
  end

  def loan_product_data_node
    loan_product_data = Ox::Element.new("LOAN_PRODUCT_DATA")

    loan_features = Ox::Element.new("LOAN_FEATURES")
    loan_features["BalloonIndicator"] = loan.balloon_payment_text.nil? ? "N" : "Y"
    loan_features["GSEPropertyType"] = subject_property.property_type.to_s == "condo" ? "03" : "01"
    loan_features["LienPriorityType"] = "1"
    loan_features["LoanRepaymentType"] = "N"
    loan_product_data << loan_features

    loan_product_data
  end

  def loan_purpose_node
    loan_purpose = Ox::Element.new("LOAN_PURPOSE")

    loan_purpose["_Type"] = loan.purpose == "purchase" ? "16" : "05"
    loan_purpose["PropertyRightsType"] = "1"
    loan_purpose["PropertyUsageType"] = get_property_usage(subject_property.usage)

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

    mortgage_terms["BaseLoanAmount"] = format("%0.02f", loan.amount.to_f)
    mortgage_terms["LoanAmortizationTermMonths"] = loan.num_of_months.to_s
    mortgage_terms["LoanAmortizationType"] = get_amortization_type(loan.amortization_type)
    mortgage_terms["MortgageType"] = get_loan_type(loan.loan_type)
    mortgage_terms["RequestedInterestRatePercent"] = format("%0.03f", loan.interest_rate.to_f * 100)

    mortgage_terms
  end

  def property_node
    property = Ox::Element.new("PROPERTY")

    address = subject_property.address
    property["_StreetAddress"] = address.nil? ? "" : address.street_address
    property["_City"] = address.nil? ? "" : address.city
    property["_State"] = address.nil? ? "" : address.state
    property["_PostalCode"] = address.nil? ? "" : address.zip
    # todo, skip now
    property["_FinancedNumberOfUnits"] = ""

    legal_description = Ox::Element.new("_LEGAL_DESCRIPTION")
    legal_description["_Type"] = "F1"
    property << legal_description

    parsed_street_address = Ox::Element.new("PARSED_STREET_ADDRESS")
    parsed_street_address["_HouseNumber"] = get_house_number(address)
    parsed_street_address["_StreetName"] = get_street_name(address)
    property << parsed_street_address

    property
  end

  def proposed_housing_expense_node_of_first_mortgage
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = "26"

    if loan.monthly_payment.present?
      proposed_housing_expense["_PaymentAmount"] = format("%0.02f", loan.monthly_payment.to_f)
    end

    proposed_housing_expense
  end

  def proposed_housing_expense_node_of_hazard_insurance
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = "01"

    if subject_property.estimated_hazard_insurance.present?
      proposed_housing_expense["_PaymentAmount"] = format("%0.02f", subject_property.estimated_hazard_insurance.to_f)
    end

    proposed_housing_expense
  end

  def proposed_housing_expense_node_of_estate_tax
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = "14"

    if subject_property.estimated_property_tax.present?
      proposed_housing_expense["_PaymentAmount"] = format("%0.02f", subject_property.estimated_property_tax.to_f)
    end

    proposed_housing_expense
  end

  def proposed_housing_expense_node_of_mortgage_insurance
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = "02"

    if loan.pmi_monthly_premium_amount.present?
      proposed_housing_expense["_PaymentAmount"] = format("%0.02f", loan.pmi_monthly_premium_amount.to_f)
    end

    proposed_housing_expense
  end

  def proposed_housing_expense_node_of_homeowner
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")

    proposed_housing_expense["HousingExpenseType"] = "06"

    if subject_property.hoa_due.present?
      proposed_housing_expense["_PaymentAmount"] = format("%0.02f", subject_property.hoa_due.to_f)
    end

    proposed_housing_expense
  end

  def proposed_housing_expense_node_of_other_mortgage
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")
    proposed_housing_expense["HousingExpenseType"] = "22"
    proposed_housing_expense
  end

  def proposed_housing_expense_node_of_other_housing
    proposed_housing_expense = Ox::Element.new("PROPOSED_HOUSING_EXPENSE")
    proposed_housing_expense["HousingExpenseType"] = "23"
    proposed_housing_expense
  end

  def title_holder_node
    title_holder = Ox::Element.new("TITLE_HOLDER")

    title_holder["_Name"] = borrower.user.to_s

    title_holder
  end

  def transaction_detail_node
    transaction_detail = Ox::Element.new("TRANSACTION_DETAIL")

    transaction_detail["BorrowerPaidDiscountPointsTotalAmount"] = format("%0.02f", loan.lender_credits.to_f)
    transaction_detail["EstimatedClosingCostsAmount"] = format("%0.02f", loan.estimated_closing_costs.to_f)

    transaction_detail
  end

  def borrower_node(borrower_params, is_borrower)
    borrower_element = Ox::Element.new("BORROWER")

    borrower_element["_FirstName"] = borrower_params.user.first_name.to_s
    borrower_element["_LastName"] = borrower_params.user.last_name.to_s
    borrower_element["_AgeAtApplicationYears"] = get_age(borrower_params.dob)
    borrower_element["_BirthDate"] = borrower_params.dob.nil? ? "" : borrower_params.dob.strftime("%Y%m%d")
    borrower_element["_HomeTelephoneNumber"] = borrower_params.phone.to_s.gsub!(/[() -]/, "")
    borrower_element["_PrintPositionType"] = is_borrower ? "BW" : "QZ"
    borrower_element["_SSN"] = borrower_params.ssn.to_s.gsub!(/[() -]/, "")
    borrower_element["JointAssetLiabilityReportingType"] = co_borrower.present? ? "Y" : "N"
    borrower_element["MaritalStatusType"] = get_marital_status(borrower_params.marital_status)
    borrower_element["SchoolingYears"] = borrower_params.years_in_school.to_s

    borrower_address = borrower_params.current_address.address
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
    borrower_element << residence

    # maybe has many
    # todo
    current_employment = borrower_params.current_employment
    if current_employment.present?
      current_income = Ox::Element.new("CURRENT_INCOME")
      # monthly, semimonthly, weekly, biweekly
      current_income["IncomeType"] = ""
      current_income["_MonthlyTotalAmount"] = format("%0.02f", get_monthly_total_amount(current_employment))
      borrower_element << current_income
    end

    borrower_declaration = borrower_params.declaration
    declaration = Ox::Element.new("DECLARATION")
    declaration["AlimonyChildSupportObligationIndicator"] = get_declaration(borrower_declaration.child_support)
    declaration["BankruptcyIndicator"] = get_declaration(borrower_declaration.bankrupt)
    declaration["BorrowedDownPaymentIndicator"] = get_declaration(borrower_declaration.down_payment_borrowed)
    declaration["CitizenshipResidencyType"] = get_residency_type(borrower_declaration)
    declaration["CoMakerEndorserOfNoteIndicator"] = get_declaration(borrower_declaration.co_maker_or_endorser)
    declaration["LoanForeclosureOrJudgementIndicator"] = get_declaration(borrower_declaration.loan_foreclosure)
    declaration["OutstandingJudgementsIndicator"] = get_declaration(borrower_declaration.outstanding_judgment)
    declaration["PartyToLawsuitIndicator"] = get_declaration(borrower_declaration.party_to_lawsuit)
    declaration["PresentlyDelinquentIndicator"] = get_declaration(borrower_declaration.present_delinquent_loan)
    declaration["PropertyForeclosedPastSevenYearsIndicator"] = get_declaration(borrower_declaration.property_foreclosed)
    borrower_element << declaration

    if current_employment.present?
      employer = Ox::Element.new("EMPLOYER")
      employer["_Name"] = current_employment.employer_name
      employer["CurrentEmploymentYearsOnJob"] = current_employment.duration
      employer["EmploymentBorrowerSelfEmployedIndicator"] = borrower_params.self_employed == true ? "Y" : "N"
      employer["EmploymentCurrentIndicator"] = current_employment.is_current == true ? "Y" : "N"
      borrower_element << employer
    end

    contact_point = Ox::Element.new("CONTACT_POINT")
    contact_point["_Type"] = "Email"
    contact_point["_Value"] = borrower_params.user.email.to_s
    borrower_element << contact_point

    borrower_element
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

  def get_property_usage(usage)
    case usage
    when "primary_residence"
      return "1"
    when "vacation_home"
      return "2"
    when "rental_property"
      return "3"
    else
      return ""
    end
  end

  def get_liability_type(account_type)
    return "" if account_type.nil?

    case account_type
    when "Mortgage"
      return "M"
    when "Installment"
      return "I"
    when "Revolving"
      return "R"
    when "Open"
      return "O"
    else
      return account_type
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

  def get_monthly_total_amount(current_employment)
    case current_employment.pay_frequency
    when "monthly"
      return current_employment.current_salary.to_f
    when "semimonthly"
      return current_employment.current_salary.to_f * 2
    when "biweekly"
      return current_employment.current_salary.to_f * 26 / 12
    when "weekly"
      return current_employment.current_salary.to_f * 52 / 12
    else
      return 0
    end
  end

  def get_loan_type(loan_type)
    case loan_type
    when "Conventional"
      return "01"
    when "VA"
      return "02"
    when "FHA"
      return "03"
    when "USDA"
      return "04"
    else
      return ""
    end
  end

  def get_house_number(address)
    return "" if address.nil?
    return "" if address.street_address.nil?

    address.street_address.match(" ").pre_match
  end

  def get_street_name(address)
    return "" if address.nil?
    return "" if address.street_address.nil?

    address.street_address.match(" ").post_match
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

  def get_age(dob)
    return "" if dob.nil?

    now = Time.zone.now
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def get_residency_type(declaration)
    return "" if declaration.citizen_status.nil?
    return "01" if declaration.citizen_status == "C"
    return "03" if declaration.citizen_status == "PR"

    "05"
  end

  def get_declaration(declaration)
    return "" if borrower.declaration.nil?

    declaration == true ? "Y" : "N"
  end
end
# rubocop:enable ClassLength
# rubocop:enable AbcSize
