module CreditReportServices
  class Base
    def self.call(borrower, address)
      cache_key = "credit-report-#{borrower.id}-#{borrower.ssn}"
      credit_report = borrower.credit_report

      # load liablities from database if cache key was not changed
      return credit_report.liabilities if REDIS.get(cache_key) && credit_report

      # get credit report for new SSN
      # destroy old liablities
      credit_report.liabilities.destroy_all if has_liabilities?(credit_report)

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
      REDIS.set(cache_key, response.to_json)
      REDIS.expire(cache_key, 1.week.to_i)

      CreditReportServices::ParseReport.call(borrower, response)
    end

    def self.has_liabilities?(credit_report)
      return false unless credit_report.present?
      return false if credit_report.liabilities.blank?

      true
    end
  end
end
