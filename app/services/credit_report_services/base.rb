module CreditReportServices
  class Base
    def self.call(borrower, address)
      response = CreditReportServices::GetReport.new(
        borrower_id: borrower.id,
        first_name: borrower.first_name,
        last_name: borrower.last_name,
        ssn: borrower.ssn,
        street_address: address.street_address,
        city: address.city,
        state: address.state,
        zipcode: address.zip
      ).call

      return [] unless response

      CreditReportServices::ParseReport.call(borrower, response)
    end
  end
end