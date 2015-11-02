module CreditReportServices
  class ParseSampleXml
    def self.call
      f = File.open('documents/Sample Credit Report.xml')
      doc = Nokogiri::XML(f, nil, 'utf-8')
      f.close

      doc.css('CREDIT_LIABILITY').each do |credit_liability|
        liability = Liability.new
        liability.account_type = credit_liability.attributes['_AccountType'].value
        liability.payment = credit_liability.attributes['_MonthlyPaymentAmount'].value
        liability.balance = credit_liability.attributes['_UnpaidBalanceAmount'].value

        liability.phone = credit_liability.css('_CREDITOR').css('CONTACT_DETAIL').css('CONTACT_POINT').first.attributes['_Value'].value
        creditor_attributes = credit_liability.css('_CREDITOR').first.attributes
        liability.name = creditor_attributes['_Name'].value
        next if !liability.valid? or duplicate?(liability)

        street_address = creditor_attributes['_StreetAddress'].value
        city = creditor_attributes['_City'].value
        state = creditor_attributes['_State'].value
        postal_code = creditor_attributes['_PostalCode'].value
        liability.create_address(street_address: street_address, city: city, state: state, zip: postal_code)

        liability.save
      end
    end

    def self.duplicate?(liability)
      Liability.all.each do |l|
        if liability.account_type == l.account_type &&
          liability.payment == l.payment &&
          liability.name == l.name
          return true
        end
      end
      false
    end
  end
end