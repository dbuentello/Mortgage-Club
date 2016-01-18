module CompletedLoanServices
  class TabProperty < Base
    def self.call(loan)
      @loan = loan
      return false unless property_completed?
      return false unless purpose_completed?

      true
    end

    def self.property_completed?
      return false unless @loan.properties.size > 0
      return false unless @loan.subject_property
      return false unless subject_property_completed?

      true
    end

    def self.subject_property_completed?
      property = @loan.subject_property

      return false unless property.address.present?
      return false unless address_completed?(property.address)
      return false unless property.usage.present?

      true
    end

    def self.purpose_completed?
      return false unless @loan.purpose.present?

      if @loan.purchase?
        return false unless @loan.subject_property.purchase_price.present?
      end

      if @loan.refinance?
        return false unless refinance_completed?
      end

      true
    end

    def refinance_completed?
      property = @loan.subject_property

      return false unless property.original_purchase_price.present?
      return false unless property.original_purchase_year.present?

      true
    end
  end
end
