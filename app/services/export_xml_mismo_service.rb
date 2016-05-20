class ExportXmlMismoService
  attr_accessor :loan, :borrower, :subject_property, :primary_property, :credit_report, :params
  def initialize(loan, borrower)
    @loan = loan
    @subject_property = loan.subject_property
    @primary_property = get_primary_property
    @borrower = loan.borrower
    @credit_report = borrower.credit_report
    @params = {}
  end

  def call
    build_data_information
    build_additional_case_data
    build_asset
    build_government_reporting
    build_interviewer_information
    build_liability
    build_loan_product_data
    build_loan_purpose
    build_loan_qualification
    build_mortgage_term
    build_property
    build_proposed_housing_expense
  end

  def build_data_information
    params["_DATA_INFORMATION"] = {
      "DATA_VERSION" => {
        "_Name" =>,
        "_Number" =>
      }
    }
  end

  def build_additional_case_data
    params["ADDITIONAL_CASE_DATA"] = {
      "TRANSMITTAL_DATA" => {
        "BelowMarketSubordinateFinancingIndicator" =>,
        "BuydownRatePercent" =>,
        "CurrentFirstMortgageHolderType" =>,
        "PropertyEstimatedValueAmount" =>,
        "InvestorLoanIdentifier" =>,
        "InvestorInstitutionIdentifier" =>,
        "LoanOriginatorID" =>,
        "LoanOriginationCompanyID" =>,
        "FIPSCodeIdentifier" =>,
      }
    }
  end

  def build_affordable_lending
    params["AFFORDABLE_LENDING"] = {
      "FNMCommunityLendingProductType" =>,
      "FNMCommunitySecondsIndicator" =>,
      "FNMNeighborsMortgageEligibilityIndicator" =>,
      "HUDIncomeLimitAdjustmentFactor" =>,
      "HUDLendingIncomeLimitAmount" =>,
      "HUDMedianIncomeAmount" =>,
    }
  end

  def build_asset
    params["ASSET"] = {
      "_CashOrMarketValueAmount" =>,
      "_Type" =>,
      "BorrowerID" =>
    }
  end

  def build_government_reporting
    params["GOVERNMENT_REPORTING"] = {
      "HMDA_HOEPALoanStatusIndicator" =>,
      "HMDAPreapprovalType" =>
    }
  end

  def build_interviewer_information
    params["INTERVIEWER_INFORMATION"] = {
      "InterviewersEmployerStreetAddress" =>,
      "InterviewersEmployerCity" =>,
      "InterviewersEmployerState" =>,
      "InterviewersEmployerPostalCode" =>,
      "InterviewersTelephoneNumber" =>,
      "ApplicationTakenMethodType" =>,
      "InterviewerApplicationSignedDate" =>,
      "InterviewersEmployerName" =>,
      "InterviewersName" =>
    }
  end

  def build_liability
    params["LIABILITY"] = {
      "_ID" =>,
      "BorrowerID" =>,
      "_AccountIdentifier" =>,
      "_ExclusionIndicator" =>,
      "_HolderName" =>,
      "_MonthlyPaymentAmount" =>,
      "_PayoffStatusIndicator" =>,
      "_RemainingTermMonths" =>,
      "_Type" =>,
      "_UnpaidBalanceAmount" =>,
      "SubjectLoanResubordinationIndicator" =>,
      "FNMSubjectPropertyIndicator" =>,
      "FNMRentalPropertyIndicator" =>
    }
  end

  def build_loan_product_data
    params["LOAN_PRODUCT_DATA"] = {
      "BUYDOWN" => {
        "_BaseDateType" =>,
        "_DurationMonths" =>,
        "_IncreaseRatePercent" =>,
        "_LenderFundingIndicator" =>,
        "_PermanentIndicator" =>,
      },
      "LOAN_FEATURES" => {
        "BalloonIndicator" =>,
        "EscrowWaiverIndicator" =>,
        "GSEProjectClassificationType" =>,
        "GSEPropertyType" =>,
        "LienPriorityType" =>,
        "LoanRepaymentType" =>,
        "PaymentFrequencyType" =>,
      }
    }
  end

  def build_loan_purpose
    params["LOAN_PURPOSE"] = {
      "GSETitleMannerHeldDescription" =>,
      "_Type" =>,
      "PropertyRightsType" =>,
      "PropertyUsageType" =>,
      "CONSTRUCTION_REFINANCE_DATA" => {
        "RefinanceImprovementsType" =>,
      }
    }
  end

  def build_loan_qualification
    params["LOAN_QUALIFICATION"] = {
      "AdditionalBorrowerAssetsNotConsideredIndicator" =>,
      "AdditionalBorrowerAssetsConsideredIndicator" =>
    }
  end

  def build_mortgage_term
    params["MORTGAGE_TERMS"] = {
      "BaseLoanAmount" =>,
      "LenderCaseIdentifier" =>,
      "LoanAmortizationTermMonths" =>,
      "LoanAmortizationType" =>,
      "MortgageType" =>,
      "RequestedInterestRatePercent" =>
    }
  end

  def build_property
    params["PROPERTY"] = {
      "_StreetAddress" =>,
      "_City" =>,
      "_State" =>,
      "_PostalCode" =>,
      "_FinancedNumberOfUnits" =>,
      "_StructureBuiltYear" =>
      "_LEGAL_DESCRIPTION" => {
        "_Type" =>
      },
      "PARSED_STREET_ADDRESS" => {
        "_HouseNumber" =>,
        "_StreetName" =>
      },
      "_VALUATION" => {
        "_MethodType" =>,
        "APPRAISER" => {
          "_Name" =>,
          "_CompanyName" =>,
          "_LicenseIdentifier" =>,
          "_LicenseState" =>,
          "_SupervisoryAppraiserLicenseNumber" =>
        }
      }
    }
  end

  def build_proposed_housing_expense
    params["PROPOSED_HOUSING_EXPENSE"] = {
      "HousingExpenseType" =>,
      "_PaymentAmount" =>
    }
  end
end
