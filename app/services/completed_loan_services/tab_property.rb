module CompletedLoanServices
  class TabProperty
    attr_accessor :loan, :subject_property

    def initialize(args)
      @loan = args[:loan]
      @subject_property = args[:subject_property]
    end

    def call
      return false unless property_completed?
      return false unless purpose_completed?

      true
    end

    def property_completed?
      return false unless loan.properties.size > 0
      return false unless subject_property
      return false unless subject_property_completed?(subject_property)

      true
    end

    def subject_property_completed?(property)
      return false unless property.property_type.present?
      return false unless property.address.present?
      return false unless address_completed?(property.address)
      return false unless property.usage.present?
      return false unless property.market_price.present?
      return false unless property.mortgage_includes_escrows.present?
      return false unless property.estimated_property_tax.present?
      return false unless property.estimated_hazard_insurance.present?

      true
    end

    def purpose_completed?
      return false unless loan.purpose.present?

      if loan.purchase?
        return false unless subject_property.purchase_price.present?
      end

      if loan.refinance?
        return false unless refinance_completed?
      end

      true
    end

    def refinance_completed?
      return false unless subject_property.original_purchase_price.present?
      return false unless subject_property.original_purchase_year.present?

      true
    end

    def address_completed?(address)
      components = [
        address.street_address,
        address.street_address2,
        address.city,
        address.state
      ].compact.reject{|x| x.blank?}

      txt_address = components.empty? ? address.full_text : "#{components.join(', ')} #{address.zip}"

      txt_address.present?
    end
  end
end
