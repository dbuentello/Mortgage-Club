# create liabilities of borrowers.
module CreditReportServices
  class CreateLiabilities
    def self.call(loan, response)
      doc = Nokogiri::XML(response)
      generate_credit_report(loan.borrower, doc)
      generate_credit_report(loan.secondary_borrower, doc) if loan.secondary_borrower
    end

    def self.generate_credit_report(borrower, doc)
      credit_report = borrower.credit_report || borrower.create_credit_report
      credit_report.update(date: Time.zone.today, score: get_credit_score(doc))

      doc.css('CREDIT_LIABILITY').each do |credit_liability|
        liability = Liability.new(credit_report_id: credit_report.id)
        liability.assign_attributes(get_liability_attributes(credit_liability))

        next if liability.payment.to_f <= 0 || duplicate?(credit_report, liability)

        address = liability.build_address
        address.assign_attributes(get_address_attributes(credit_liability))
        liability.save
      end
    end

    def self.duplicate?(credit_report, liability)
      credit_report.liabilities.each do |l|
        return true if l.id.present? && liability.account_type == l.account_type && liability.payment == l.payment && liability.name == l.name
      end
      false
    end

    def self.get_liability_attributes(credit_liability)
      return {} unless creditor = get_creditor(credit_liability)

      {
        account_type: credit_liability.attributes['_AccountType'].value,
        account_number: credit_liability.attributes['_AccountIdentifier'],
        payment: credit_liability.attributes['_MonthlyPaymentAmount'] ? credit_liability.attributes['_MonthlyPaymentAmount'].value.to_f : nil,
        balance: credit_liability.attributes['_UnpaidBalanceAmount'] ? credit_liability.attributes['_UnpaidBalanceAmount'].value.to_f : nil,
        phone: creditor.css('CONTACT_DETAIL').empty? ? nil : creditor.css('CONTACT_DETAIL').css('CONTACT_POINT').first.attributes['_Value'].value,
        name: creditor.attributes['_Name'].value
      }
    end

    def self.get_address_attributes(credit_liability)
      creditor = get_creditor(credit_liability)
      return {} unless creditor.attributes['_StreetAddress'] && creditor.attributes['_City'] && creditor.attributes['_State'] && creditor.attributes['_PostalCode']

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
      scores = doc.css('CREDIT_SCORE').map { |credit_score| credit_score.attributes['_Value'].value if credit_score.attributes['_Value'] }.compact
      scores[1].to_f
    end
  end
end
