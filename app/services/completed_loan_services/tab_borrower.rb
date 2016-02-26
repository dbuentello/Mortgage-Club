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
      return false unless borrower
      return false if borrower.self_employed.nil?
      return false unless borrower.first_name.present?
      return false unless borrower.last_name.present?
      return false unless borrower.ssn.present?
      return false unless borrower.dob.present?
      return false unless borrower.years_in_school.present?
      return false unless borrower.marital_status.present?
      return false unless borrower.dependent_count
      return false if borrower.dependent_ages.blank? && borrower.dependent_count >= 1
      return false unless borrower.current_address
      return false if borrower.current_address.is_rental.nil?
      return false unless borrower.current_address.years_at_address
      return false if borrower.current_address.years_at_address < 0
      return false unless address_completed?(borrower.current_address.address)
      return false if rent_house_and_monthly_rent_valid?(borrower.current_address)
      return false unless previous_address_completed?(borrower)

      true
    end

    def previous_address_completed?(borrower)
      return false unless borrower
      return true if borrower.current_address.years_at_address > 1
      return false unless borrower.previous_address.present?
      return false if borrower.previous_address.is_rental.nil?
      return false if rent_house_and_monthly_rent_valid?(borrower.previous_address)

      true
    end

    def rent_house_and_monthly_rent_valid?(address)
      address.is_rental && !address.monthly_rent
    end

    def address_completed?(address)
      return false unless address
      return false if address.street_address.blank? || address.city.blank? || address.state.blank? || address.zip.blank?

      address.full_text.present?
    end
  end
end
