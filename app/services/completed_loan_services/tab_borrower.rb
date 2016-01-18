module CompletedLoanServices
  class TabBorrower
    attr_accessor :borrower, :secondary_borrower

    def initialize(args)
      @borrower = args[:borrower]
      @secondary_borrower = args[:secondary_borrower]
    end

    def call
      return borrower_completed?(borrower) unless secondary_borrower.present?
      borrower_completed?(borrower) && borrower_completed?(secondary_borrower)
    end

    def borrower_completed?(borrower)
      return false if borrower.self_employed.nil?
      return false unless borrower.first_name.present?
      return false unless borrower.last_name.present?
      return false unless borrower.ssn.present?
      return false unless borrower.dob.present?
      return false unless borrower.years_in_school.present?
      return false unless borrower.marital_status.present?
      return false unless borrower.dependent_count
      return false if borrower.dependent_count > 0 && borrower.dependent_ages.blank?
      return false unless borrower.current_address
      return false if borrower.current_address.is_rental.nil?
      return false unless borrower.current_address.years_at_address
      return false if borrower.current_address.years_at_address < 0
      return false if borrower.current_address.is_rental && !borrower.current_address.monthly_rent
      return false unless previous_address_completed?(borrower)

      true
    end

    def previous_address_completed?(borrower)
      if borrower.previous_address.present?
        return false if borrower.previous_address.is_rental.nil?
        return false unless borrower.previous_address.monthly_rent
      end

      true
    end
  end
end
