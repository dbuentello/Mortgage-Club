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
  end

  def build_data_information
  end

  def build_additional_case_data
  end
end
