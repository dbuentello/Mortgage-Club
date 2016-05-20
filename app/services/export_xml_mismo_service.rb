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
    build_title_holder
    build_transaction_detail
    build_borrower
  end

  def build_data_information
  end

  def build_additional_case_data
  end

  def build_title_holder
    params["TITLE_HOLDER"] = {
      "_Name" => borrower.user.to_s
    }
  end

  def build_transaction_detail
    purchase_credit = {
      "_Amount" => "",
      "_SourceType" => ""
    }

    params["TRANSACTION_DETAIL"] = {
      "AlterationsImprovementsAndRepairsAmount" => "",
      "BorrowerPaidDiscountPointsTotalAmount" => "",
      "EstimatedClosingCostsAmount" => "",
      "MIAndFundingFeeFinancedAmount" => "",
      "MIAndFundingFeeTotalAmount" => "",
      "PrepaidItemsEstimatedAmount" => "",
      "PurchasePriceAmount" => "",
      "RefinanceIncludingDebtsToBePaidOffAmount" => "",
      "SellerPaidClosingCostsAmount" => "",
      "SubordinateLienAmount" => "",
      "FNMCostOfLandAcquiredSeparatelyAmount" => "",
      "PURCHASE_CREDIT" => purchase_credit
    }
  end

  def build_borrower
    mail_to = {
      "_StreetAddress" => "",
      "_City" => "",
      "_State" => "",
      "_PostalCode" => "",
      "_Country" =>
    }

    residence = {
      "_StreetAddress" => "",
      "_City" => "",
      "_State" => "",
      "_PostalCode" => "",
      "BorrowerResidencyBasisType" => "",
      "BorrowerResidencyDurationMonths" => "",
      "BorrowerResidencyDurationYears" => "",
      "BorrowerResidencyType" => ""
    }

    current_income = {
      "IncomeType" => "",
      "_MonthlyTotalAmount" => ""
    }

    declaration = {
      "AlimonyChildSupportObligationIndicator" => "",
      "BankruptcyIndicator" => "",
      "BorrowedDownPaymentIndicator" => "",
      "CitizenshipResidencyType" => "",
      "CoMakerEndorserOfNoteIndicator" => "",
      "HomeownerPastThreeYearsType" => "",
      "IntentToOccupyType" => "",
      "LoanForeclosureOrJudgementIndicator" => "",
      "OutstandingJudgementsIndicator" => "",
      "PartyToLawsuitIndicator" => "",
      "PresentlyDelinquentIndicator" => "",
      "PropertyForeclosedPastSevenYearsIndicator" => ""
    }

    employer = {
      "_Name" => "",
      "CurrentEmploymentMonthsOnJob" => "",
      "CurrentEmploymentTimeInLineOfWorkYears" => "",
      "CurrentEmploymentYearsOnJob" => "",
      "EmploymentBorrowerSelfEmployedIndicator" => "",
      "EmploymentCurrentIndicator" => "",
      "EmploymentPrimaryIndicator" => ""
    }

    government_monitoring = {
      "GenderType" => "",
      "RaceNationalOriginRefusalIndicator" => "",
      "HMDAEthnicityType" => "",
      "HMDA_RACE" => {
        "_Type" => ""
      }
    }

    present_housing_expense = {
      "HousingExpenseType" => ""
    }

    summary = {
      "_Amount" => "",
      "_AmountType" => ""
    }

    contact_point = {
      "_Type" => "",
      "_Value" => ""
    }

    params["BORROWER"] = {
      "BorrowerID" => "",
      "_FirstName" => "",
      "_LastName" => "",
      "_AgeAtApplicationYears" => "",
      "_BirthDate" => "",
      "_HomeTelephoneNumber" => "",
      "_PrintPositionType" => "",
      "_SSN" => "",
      "JointAssetLiabilityReportingType" => "",
      "MaritalStatusType" => "",
      "SchoolingYears" => "",
      "_MAIL_TO" => mail_to,
      "_RESIDENCE" => residence,
      "CURRENT_INCOME" => current_income (many),
      "DECLARATION" => declaration,
      "EMPLOYER" => employer,
      "GOVERNMENT_MONITORING" => government_monitoring,
      "PRESENT_HOUSING_EXPENSE" => present_housing_expense (many),
      "SUMMARY" => summary (many),
      "CONTACT_POINT" => contact_point
    }
  end
end
