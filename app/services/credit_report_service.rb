class CreditReportService
  include HTTParty

  def self.get_info
    report = Hash.from_xml(File.open("#{Rails.root}/vendor/files/Sample Credit Report.xml"))
    liabilities = report["RESPONSE_GROUP"]["RESPONSE"]["RESPONSE_DATA"]["CREDIT_RESPONSE"]["CREDIT_LIABILITY"]

    liabilities.each do |liability|
      break if liability["_CREDITOR"].nil?

      ap liability

      ap liability["_AccountType"]
      ap liability["_MonthlyPaymentAmount"]
      ap liability["_UnpaidBalanceAmount"]

      ap liability["_CREDITOR"]["CONTACT_DETAIL"]["CONTACT_POINT"]["_Value"]
      ap liability["_CREDITOR"]["_Name"]
      ap liability["_CREDITOR"]["_StreetAddress"]
      ap liability["_CREDITOR"]["_City"]
      ap liability["_CREDITOR"]["_State"]
      ap liability["_CREDITOR"]["_PostalCode"]

      # l.name = liability["_CREDITOR"]["_Name"]
      # l.address.street_address = liability["_CREDITOR"]["_StreetAddress"]
      # l.address.city = liability["_CREDITOR"]["_City"]
      # l.address.state = liability["_CREDITOR"]["_State"]
      # l.address.zip = liability["_CREDITOR"]["_PostalCode"]

    end
  end

end
