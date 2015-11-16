module CreditReportServices
  class ParseSampleXml
    FILE_PATH = 'vendor/files/Sample Credit Report.xml'.freeze

    def self.call(borrower)
      return [] unless File.exist?(FILE_PATH)

      doc = read_file
      credit_report = borrower.credit_report || borrower.create_credit_report
      credit_report.update(date: Time.zone.today, score: get_credit_score(doc))

      doc.css('CREDIT_LIABILITY').each do |credit_liability|
        liability = credit_report.liabilities.build
        liability.assign_attributes(get_liability_attributes(credit_liability))
        next if liability.payment <= 0 || duplicate?(credit_report, liability)

        address = liability.build_address
        address.assign_attributes(get_address_attributes(credit_liability))
        liability.save
      end
      credit_report.reload
      credit_report.liabilities
    end

    def self.read_file
      file = File.open(FILE_PATH)
      doc = Nokogiri::XML(file, nil, 'utf-8')
      file.close
      doc
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

    def self.get_liability_attributes(credit_liability)
      creditor = get_creditor(credit_liability)
      {
        account_type: credit_liability.attributes['_AccountType'].value,
        payment: credit_liability.attributes['_MonthlyPaymentAmount'].value.to_f,
        balance: credit_liability.attributes['_UnpaidBalanceAmount'].value.to_f,
        phone: creditor.css('CONTACT_DETAIL').css('CONTACT_POINT').first.attributes['_Value'].value,
        name: creditor.attributes['_Name'].value
      }
    end

    def self.get_address_attributes(credit_liability)
      creditor = get_creditor(credit_liability)
      {
        street_address: creditor.attributes['_StreetAddress'].value,
        city: creditor.attributes['_City'].value,
        state: creditor.attributes['_State'].value,
        zip: creditor.attributes['_PostalCode'].value
      }
    end

    def self.get_creditor(credit_liability)
      credit_liability.css('_CREDITOR').first
    end

    def self.get_credit_score(doc)
      scores = doc.css('CREDIT_SCORE').map { |credit_score| credit_score.attributes['_Value'].value }
      scores[1].to_f
    end
  end
end