module CompletedLoanServices
  class TabBorrower < Base
    def self.call(loan)
      @loan = loan

      return borrower_completed?(@loan.borrower) unless @loan.secondary_borrower.present?
      borrower_completed?(@loan.borrower) && borrower_completed?(@loan.secondary_borrower)
    end

    def self.borrower_completed?(borrower)
      return false if borrower.self_employed.nil?
      return false unless borrower.first_name.present?
      return false unless borrower.last_name.present?
      return false unless borrower.ssn.present?
      return false unless borrower.dob.present?
      return false unless borrower.years_in_school.present?
      return false unless borrower.marital_status.present?
      return false unless borrower.dependent_count
      return false if (borrower.dependent_count > 0 && borrower.dependent_ages.blank?)
      return false unless borrower.current_address
      return false if borrower.current_address.is_rental.nil?
      return false unless borrower.current_address.years_at_address
      return false if borrower.current_address.years_at_address < 0

      if borrower.current_address.is_rental
        return false unless borrower.current_address.monthly_rent
      end
      return false unless previous_address_completed?(borrower)

      true
    end

    def self.previous_address_completed?(borrower)
      if borrower.previous_address.present?
        return false if borrower.previous_address.is_rental.nil?
        return false unless borrower.previous_address.monthly_rent
      end

      true
    end
  end
end
