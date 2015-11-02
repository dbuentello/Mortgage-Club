module CreditReportServices
  class ParseSampleXml
    def self.call(borrower)
      f = File.open('vendor/files/Sample Credit Report.xml')
      doc = Nokogiri::XML(f, nil, 'utf-8')
      f.close

      credit_report = borrower.credit_report || borrower.create_credit_report
      credit_report.update(date: Time.zone.today)

      doc.css('CREDIT_LIABILITY').each do |credit_liability|
        liability = credit_report.liabilities.build
        liability.account_type = credit_liability.attributes['_AccountType'].value
        liability.payment = credit_liability.attributes['_MonthlyPaymentAmount'].value
        liability.balance = credit_liability.attributes['_UnpaidBalanceAmount'].value

        liability.phone = credit_liability.css('_CREDITOR').css('CONTACT_DETAIL').css('CONTACT_POINT').first.attributes['_Value'].value
        creditor_attributes = credit_liability.css('_CREDITOR').first.attributes
        liability.name = creditor_attributes['_Name'].value

        next if liability.payment <= 0 || duplicate?(credit_report, liability)

        address = liability.build_address
        address.street_address = creditor_attributes['_StreetAddress'].value
        address.city = creditor_attributes['_City'].value
        address.state = creditor_attributes['_State'].value
        address.zip = creditor_attributes['_PostalCode'].value

        liability.save
      end
      credit_report.reload
      credit_report.liabilities
    end

    def self.duplicate?(credit_report, liability)
      credit_report.liabilities.each do |l|
        if l.id.present? && liability.account_type == l.account_type &&
          liability.payment == l.payment &&
          liability.name == l.name
          return true
        end
      end
      false
    end

  end
end