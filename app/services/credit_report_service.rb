class CreditReportService
  include HTTParty

  def self.get_liabilities(borrower)
    report = Hash.from_xml(File.open("#{Rails.root}/vendor/files/Sample Credit Report.xml"))
    liabilities_info = report["RESPONSE_GROUP"]["RESPONSE"]["RESPONSE_DATA"]["CREDIT_RESPONSE"]["CREDIT_LIABILITY"]

    credit_report = borrower.credit_report || borrower.create_credit_report

    liabilities_info.each do |liability_info|
      break if liability_info["_CREDITOR"].nil?

      liability = credit_report.liabilities.build

      liability.account_type = liability_info["_AccountType"]
      liability.payment = liability_info["_MonthlyPaymentAmount"]
      liability.balance = liability_info["_UnpaidBalanceAmount"]

      liability.phone = liability_info["_CREDITOR"]["CONTACT_DETAIL"]["CONTACT_POINT"]["_Value"]
      liability.name = liability_info["_CREDITOR"]["_Name"]

      address = liability.build_address
      address.street_address = liability_info["_CREDITOR"]["_StreetAddress"]
      address.city = liability_info["_CREDITOR"]["_City"]
      address.state = liability_info["_CREDITOR"]["_State"]
      address.zip = liability_info["_CREDITOR"]["_PostalCode"]

      liability.save
    end
  end

end
