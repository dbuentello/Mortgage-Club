module LoanMemberServices
  class UpdateLoanTermsServices
    attr_accessor :loan_id
    def initialize(loan_id, property_id, address_id, loan_terms_params, property_params, address_params)
      @property_id = property_id
      @address_id = address_id
      @loan_id = loan_id
      @loan_terms_params = loan_terms_params
      @property_params = property_params
      @address_params = address_params
    end

    def update_loan
      loan = Loan.find(loan_id)
      create_or_update_property
      loan.update(@loan_terms_params)
      logger.error(loan.errors.full_messages) unless loan.update(@loan_terms_params)
    end

    def create_or_update_property
      property = Property.find(@property_id) if @property_id
      property = Property.create(@property_params.merge(is_subject: true)) unless property
      return property.update(@property_params) if create_or_update_address(property)
      true
    end

    def create_or_update_address(property)
      return true unless @address_params
      if @address_params[:id].present?
        address = Address.find(@address_id)
        return address.update(@address_params.except(:id))
      else
        property.build_address(@address_params.except(:id))
        return property.address.save
      end
      true
    end
  end
end
